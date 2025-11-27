//
//  CameraModalInteractor.swift
//  EmptyProject
//
//  CameraModal Module - Interactor
//

import Foundation

final class CameraModalInteractor: CameraModalInteractorInputProtocol {
    
    // MARK: - Properties
    weak var presenter: CameraModalInteractorOutputProtocol?
    
    private let userDefaults = UserDefaults.standard
    private let settingsKey = "CameraModalSettings"
    
    // MARK: - Methods
    func fetchCurrentSettings() {
        if let data = userDefaults.data(forKey: settingsKey),
           let settings = try? JSONDecoder().decode(CameraModalSettingsStorage.self, from: data) {
            let entity = CameraModalEntity(
                planeDetectionEnabled: settings.planeDetectionEnabled,
                lightEstimationEnabled: settings.lightEstimationEnabled,
                debugModeEnabled: settings.debugModeEnabled,
                selectedQuality: VideoQuality(rawValue: settings.selectedQuality) ?? .high
            )
            presenter?.didFetchSettings(entity)
        } else {
            presenter?.didFetchSettings(.default)
        }
    }
    
    func saveSettings(_ settings: CameraModalEntity) {
        let storage = CameraModalSettingsStorage(
            planeDetectionEnabled: settings.planeDetectionEnabled,
            lightEstimationEnabled: settings.lightEstimationEnabled,
            debugModeEnabled: settings.debugModeEnabled,
            selectedQuality: settings.selectedQuality.rawValue
        )
        
        if let data = try? JSONEncoder().encode(storage) {
            userDefaults.set(data, forKey: settingsKey)
        }
        
        presenter?.didSaveSettings()
    }
    
    func resetSettings() {
        userDefaults.removeObject(forKey: settingsKey)
        presenter?.didResetSettings(.default)
    }
}

// MARK: - Storage Model
private struct CameraModalSettingsStorage: Codable {
    let planeDetectionEnabled: Bool
    let lightEstimationEnabled: Bool
    let debugModeEnabled: Bool
    let selectedQuality: String
}

