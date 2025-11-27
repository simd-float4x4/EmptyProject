//
//  CameraModalPresenter.swift
//  EmptyProject
//
//  CameraModal Module - Presenter
//

import Foundation
import Combine

final class CameraModalPresenter: ObservableObject, CameraModalPresenterProtocol {
    
    // MARK: - Properties
    weak var view: CameraModalViewProtocol?
    var interactor: CameraModalInteractorInputProtocol!
    var router: CameraModalRouterProtocol!
    
    // 親のCameraPresenterへの参照（設定適用用）
    weak var cameraPresenter: CameraPresenter?
    
    // MARK: - Published Properties
    @Published private(set) var settings: CameraModalEntity = .default
    @Published var isLoading: Bool = false
    @Published var hasChanges: Bool = false
    
    // MARK: - View -> Presenter
    func viewDidLoad() {
        isLoading = true
        interactor.fetchCurrentSettings()
    }
    
    func didTogglePlaneDetection(_ isEnabled: Bool) {
        settings.planeDetectionEnabled = isEnabled
        hasChanges = true
    }
    
    func didToggleLightEstimation(_ isEnabled: Bool) {
        settings.lightEstimationEnabled = isEnabled
        hasChanges = true
    }
    
    func didToggleDebugMode(_ isEnabled: Bool) {
        settings.debugModeEnabled = isEnabled
        hasChanges = true
    }
    
    func didSelectQuality(_ quality: VideoQuality) {
        settings.selectedQuality = quality
        hasChanges = true
    }
    
    func didTapResetButton() {
        interactor.resetSettings()
    }
    
    func didTapCloseButton() {
        router.dismiss()
    }
    
    func didTapApplyButton() {
        interactor.saveSettings(settings)
    }
}

// MARK: - Interactor Output
extension CameraModalPresenter: CameraModalInteractorOutputProtocol {
    func didFetchSettings(_ settings: CameraModalEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.settings = settings
            self?.isLoading = false
            self?.hasChanges = false
        }
    }
    
    func didSaveSettings() {
        DispatchQueue.main.async { [weak self] in
            self?.hasChanges = false
            // 設定を適用後にモーダルを閉じる
            self?.router.dismiss()
        }
    }
    
    func didResetSettings(_ settings: CameraModalEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.settings = settings
            self?.hasChanges = true
        }
    }
}

