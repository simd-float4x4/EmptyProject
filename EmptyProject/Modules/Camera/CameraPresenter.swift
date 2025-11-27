//
//  CameraPresenter.swift
//  EmptyProject
//
//  Camera Module - Presenter
//

import Foundation
import Combine
import ARKit

final class CameraPresenter: ObservableObject, CameraPresenterProtocol {
    
    // MARK: - Properties
    weak var view: CameraViewProtocol?
    var interactor: CameraInteractorInputProtocol!
    var router: CameraRouterProtocol!
    
    // MARK: - Published Properties
    @Published private(set) var arSessionState: ARSessionState = .notStarted
    @Published private(set) var trackingState: ARCamera.TrackingState?
    @Published private(set) var detectedPlanes: [ARPlaneAnchor] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var capturedImage: UIImage?
    
    // MARK: - Computed Properties
    var trackingStateDescription: String {
        guard let state = trackingState else { return "初期化中..." }
        
        switch state {
        case .normal:
            return "トラッキング正常"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                return "動きが速すぎます"
            case .insufficientFeatures:
                return "特徴点が不足しています"
            case .initializing:
                return "初期化中..."
            case .relocalizing:
                return "再ローカライズ中..."
            @unknown default:
                return "制限付きトラッキング"
            }
        case .notAvailable:
            return "トラッキング利用不可"
        }
    }
    
    var detectedPlanesCount: Int {
        return detectedPlanes.count
    }
    
    // MARK: - View -> Presenter
    func viewDidLoad() {
        isLoading = true
        interactor.setupARSession()
    }
    
    func viewWillAppear() {
        interactor.startARSession()
    }
    
    func viewWillDisappear() {
        interactor.pauseARSession()
    }
    
    func didTapBackButton() {
        router.navigateBack()
    }
    
    func didTapSettingsButton() {
        router.presentSettingsModal()
    }
    
    func didTapCaptureButton() {
        capturedImage = interactor.captureCurrentFrame()
    }
    
    func getARSession() -> ARSession {
        return interactor.arSession
    }
}

// MARK: - Interactor Output
extension CameraPresenter: CameraInteractorOutputProtocol {
    func didUpdateARSessionState(_ state: ARSessionState) {
        DispatchQueue.main.async { [weak self] in
            self?.arSessionState = state
            self?.isLoading = state == .notStarted
        }
    }
    
    func didUpdateTrackingState(_ state: ARCamera.TrackingState) {
        DispatchQueue.main.async { [weak self] in
            self?.trackingState = state
        }
    }
    
    func didDetectPlane(_ anchor: ARPlaneAnchor) {
        DispatchQueue.main.async { [weak self] in
            if let index = self?.detectedPlanes.firstIndex(where: { $0.identifier == anchor.identifier }) {
                self?.detectedPlanes[index] = anchor
            } else {
                self?.detectedPlanes.append(anchor)
            }
        }
    }
    
    func didRemovePlane(_ anchor: ARPlaneAnchor) {
        DispatchQueue.main.async { [weak self] in
            self?.detectedPlanes.removeAll { $0.identifier == anchor.identifier }
        }
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = error.localizedDescription
            self?.arSessionState = .failed(error.localizedDescription)
            self?.isLoading = false
        }
    }
}

