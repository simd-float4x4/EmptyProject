//
//  CameraEntity.swift
//  EmptyProject
//
//  Camera Module - Entity
//

import Foundation
import ARKit

/// カメラ画面のエンティティ
struct CameraEntity {
    var arSessionState: ARSessionState
    var trackingState: ARCamera.TrackingState?
    var detectedPlanes: [ARPlaneAnchor]
    var isRecording: Bool
    
    static let `default` = CameraEntity(
        arSessionState: .notStarted,
        trackingState: nil,
        detectedPlanes: [],
        isRecording: false
    )
}

/// ARセッション状態
enum ARSessionState: Equatable {
    case notStarted
    case running
    case paused
    case failed(String)
    
    static func == (lhs: ARSessionState, rhs: ARSessionState) -> Bool {
        switch (lhs, rhs) {
        case (.notStarted, .notStarted),
             (.running, .running),
             (.paused, .paused):
            return true
        case (.failed(let lhsError), .failed(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

/// AR設定
struct ARConfiguration {
    var planeDetection: ARWorldTrackingConfiguration.PlaneDetection
    var environmentTexturing: ARWorldTrackingConfiguration.EnvironmentTexturing
    var isLightEstimationEnabled: Bool
    
    static let `default` = ARConfiguration(
        planeDetection: [.horizontal, .vertical],
        environmentTexturing: .automatic,
        isLightEstimationEnabled: true
    )
}

/// 検出されたオブジェクト情報
struct DetectedObject: Identifiable {
    let id: UUID
    let name: String
    let confidence: Float
    let position: SIMD3<Float>
    let timestamp: Date
    
    init(name: String, confidence: Float, position: SIMD3<Float>) {
        self.id = UUID()
        self.name = name
        self.confidence = confidence
        self.position = position
        self.timestamp = Date()
    }
}

