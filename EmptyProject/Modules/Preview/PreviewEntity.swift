//
//  PreviewEntity.swift
//  EmptyProject
//
//  Preview Module - Entity
//

import Foundation
import AVFoundation

/// プレビュー画面のエンティティ
struct PreviewEntity {
    var cameraPermissionStatus: AVAuthorizationStatus
    var isFlashEnabled: Bool
    var currentCameraPosition: AVCaptureDevice.Position
    
    static let `default` = PreviewEntity(
        cameraPermissionStatus: .notDetermined,
        isFlashEnabled: false,
        currentCameraPosition: .back
    )
}

/// カメラ設定
struct CameraSettings {
    var resolution: AVCaptureSession.Preset
    var focusMode: AVCaptureDevice.FocusMode
    var exposureMode: AVCaptureDevice.ExposureMode
    
    static let `default` = CameraSettings(
        resolution: .high,
        focusMode: .continuousAutoFocus,
        exposureMode: .continuousAutoExposure
    )
}

