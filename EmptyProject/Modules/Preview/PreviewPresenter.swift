//
//  PreviewPresenter.swift
//  EmptyProject
//
//  Preview Module - Presenter
//

import Foundation
import Combine
import AVFoundation

final class PreviewPresenter: ObservableObject, PreviewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: PreviewViewProtocol?
    var interactor: PreviewInteractorInputProtocol!
    var router: PreviewRouterProtocol!
    
    // MARK: - Published Properties
    @Published var cameraPermissionStatus: AVAuthorizationStatus = .notDetermined
    @Published var currentCameraPosition: AVCaptureDevice.Position = .back
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var captureSession: AVCaptureSession?
    
    // MARK: - View -> Presenter
    func viewDidLoad() {
        isLoading = true
        interactor.requestCameraPermission()
    }
    
    func viewWillAppear() {
        interactor.startCameraSession()
    }
    
    func viewWillDisappear() {
        interactor.stopCameraSession()
    }
    
    func didTapStartARButton() {
        router.navigateToCamera()
    }
    
    func didTapSwitchCameraButton() {
        interactor.switchCamera()
    }
    
    func didTapBackButton() {
        router.navigateBack()
    }
}

// MARK: - Interactor Output
extension PreviewPresenter: PreviewInteractorOutputProtocol {
    func didUpdateCameraPermission(_ status: AVAuthorizationStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.cameraPermissionStatus = status
            
            if status == .authorized {
                self?.interactor.setupCameraSession()
            } else {
                self?.isLoading = false
                self?.errorMessage = "カメラへのアクセスが許可されていません"
            }
        }
    }
    
    func didSetupCameraSession(_ session: AVCaptureSession) {
        DispatchQueue.main.async { [weak self] in
            self?.captureSession = session
            self?.isLoading = false
        }
    }
    
    func didFailToSetupCamera(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = error.localizedDescription
            self?.isLoading = false
        }
    }
    
    func didSwitchCamera(to position: AVCaptureDevice.Position) {
        DispatchQueue.main.async { [weak self] in
            self?.currentCameraPosition = position
        }
    }
}

