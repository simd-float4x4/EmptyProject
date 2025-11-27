//
//  MainEntity.swift
//  EmptyProject
//
//  Main Module - Entity
//

import Foundation

/// メイン画面のエンティティ
struct MainEntity {
    let title: String
    let description: String
    
    static let `default` = MainEntity(
        title: "ARKit Demo",
        description: "カメラプレビューを開始してARKit体験を始めましょう"
    )
}

