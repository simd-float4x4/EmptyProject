//
//  PreviewInteractor.swift
//  EmptyProject
//
//  Preview Module - Interactor
//

import Foundation
import AVFoundation

final class PreviewInteractor: PreviewInteractorInputProtocol {
    
    // MARK: - Properties
    weak var presenter: PreviewInteractorOutputProtocol?
    
    private(set) var captureSession: AVCaptureSession?
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    private let sessionQueue = DispatchQueue(label: "com.emptyproject.camera.session")
    
    // MARK: - Methods
    func requestCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                let newStatus: AVAuthorizationStatus = granted ? .authorized : .denied
                self?.presenter?.didUpdateCameraPermission(newStatus)
            }
        default:
            presenter?.didUpdateCameraPermission(status)
        }
    }
    
    func setupCameraSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            do {
                let session = AVCaptureSession()
                session.beginConfiguration()
                session.sessionPreset = .high
                
                // カメラデバイスの設定
                guard let camera = self.getCamera(for: self.currentCameraPosition) else {
                    throw CameraError.cameraUnavailable
                }
                
                let input = try AVCaptureDeviceInput(device: camera)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                session.commitConfiguration()
                self.captureSession = session
                
                self.presenter?.didSetupCameraSession(session)
            } catch {
                self.presenter?.didFailToSetupCamera(error)
            }
        }
    }
    
    func startCameraSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func stopCameraSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession?.stopRunning()
        }
    }
    
    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self, let session = self.captureSession else { return }
            
            // 現在のカメラポジションを切り替え
            let newPosition: AVCaptureDevice.Position = self.currentCameraPosition == .back ? .front : .back
            
            session.beginConfiguration()
            
            // 現在の入力を削除
            if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
                session.removeInput(currentInput)
            }
            
            // 新しいカメラを追加
            if let newCamera = self.getCamera(for: newPosition),
               let newInput = try? AVCaptureDeviceInput(device: newCamera),
               session.canAddInput(newInput) {
                session.addInput(newInput)
                self.currentCameraPosition = newPosition
            }
            
            session.commitConfiguration()
            
            self.presenter?.didSwitchCamera(to: self.currentCameraPosition)
        }
    }
    
    // MARK: - Private Methods
    private func getCamera(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTripleCamera],
            mediaType: .video,
            position: position
        )
        return discoverySession.devices.first
    }
}

// MARK: - Camera Error
enum CameraError: LocalizedError {
    case cameraUnavailable
    case inputCreationFailed
    case configurationFailed
    
    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "カメラが利用できません"
        case .inputCreationFailed:
            return "カメラ入力の作成に失敗しました"
        case .configurationFailed:
            return "カメラ設定に失敗しました"
        }
    }
}

