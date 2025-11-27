//
//  HomeEntity.swift
//  EmptyProject
//
//  Home Module Entity
//

import Foundation

struct HomeEntity: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let createdAt: Date
    
    init(id: UUID = UUID(), title: String, description: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
    }
}

