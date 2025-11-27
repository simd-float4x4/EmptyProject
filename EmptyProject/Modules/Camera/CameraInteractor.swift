//
//  CameraInteractor.swift
//  EmptyProject
//
//  Camera Module - Interactor
//

import Foundation
import ARKit

final class CameraInteractor: NSObject, CameraInteractorInputProtocol {
    
    // MARK: - Properties
    weak var presenter: CameraInteractorOutputProtocol?
    
    let arSession = ARSession()
    private var configuration: ARWorldTrackingConfiguration?
    
    // MARK: - Initialization
    override init() {
        super.init()
        arSession.delegate = self
    }
    
    // MARK: - Methods
    func setupARSession() {
        guard ARWorldTrackingConfiguration.isSupported else {
            presenter?.didFailWithError(ARError.deviceNotSupported)
            return
        }
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        config.isLightEstimationEnabled = true
        
        // フレームセマンティクスの設定（iOS 14以降）
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        self.configuration = config
        
        // セットアップ完了後に自動的にセッションを開始
        arSession.run(config, options: [.resetTracking, .removeExistingAnchors])
        presenter?.didUpdateARSessionState(.running)
    }
    
    func startARSession() {
        guard let config = configuration else {
            setupARSession()
            return
        }
        
        // セッションが実行中でなければ開始
        arSession.run(config)
        presenter?.didUpdateARSessionState(.running)
    }
    
    func pauseARSession() {
        arSession.pause()
        presenter?.didUpdateARSessionState(.paused)
    }
    
    func resetARSession() {
        guard let config = configuration else { return }
        arSession.run(config, options: [.resetTracking, .removeExistingAnchors])
        presenter?.didUpdateARSessionState(.running)
    }
    
    func captureCurrentFrame() -> UIImage? {
        guard let frame = arSession.currentFrame else { return nil }
        
        let ciImage = CIImage(cvPixelBuffer: frame.capturedImage)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        // 画像の向きを補正
        let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
        return image
    }
}

// MARK: - ARSessionDelegate
extension CameraInteractor: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        presenter?.didUpdateTrackingState(frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                presenter?.didDetectPlane(planeAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                presenter?.didDetectPlane(planeAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                presenter?.didRemovePlane(planeAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        presenter?.didFailWithError(error)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        presenter?.didUpdateARSessionState(.paused)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        presenter?.didUpdateARSessionState(.running)
    }
}

// MARK: - AR Error
enum ARError: LocalizedError {
    case deviceNotSupported
    case sessionFailed
    case trackingFailed
    
    var errorDescription: String? {
        switch self {
        case .deviceNotSupported:
            return "このデバイスはARKitに対応していません"
        case .sessionFailed:
            return "ARセッションの開始に失敗しました"
        case .trackingFailed:
            return "トラッキングに失敗しました"
        }
    }
}

