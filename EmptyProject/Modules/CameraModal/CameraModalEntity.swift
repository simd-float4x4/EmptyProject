//
//  CameraModalEntity.swift
//  EmptyProject
//
//  CameraModal Module - Entity
//

import Foundation

/// カメラ設定モーダルのエンティティ
struct CameraModalEntity {
    var planeDetectionEnabled: Bool
    var lightEstimationEnabled: Bool
    var debugModeEnabled: Bool
    var selectedQuality: VideoQuality
    
    static let `default` = CameraModalEntity(
        planeDetectionEnabled: true,
        lightEstimationEnabled: true,
        debugModeEnabled: false,
        selectedQuality: .high
    )
}

/// ビデオ品質
enum VideoQuality: String, CaseIterable, Identifiable {
    case low = "低"
    case medium = "中"
    case high = "高"
    case ultra = "最高"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .low: return "480p - バッテリー節約"
        case .medium: return "720p - バランス"
        case .high: return "1080p - 高品質"
        case .ultra: return "4K - 最高品質"
        }
    }
}

/// モーダル設定項目
struct ModalSettingItem: Identifiable {
    let id: UUID
    let title: String
    let icon: String
    var isEnabled: Bool
    
    init(title: String, icon: String, isEnabled: Bool = false) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
    }
}

