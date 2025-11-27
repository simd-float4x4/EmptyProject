//
//  DetailEntity.swift
//  EmptyProject
//
//  Detail Module Entity
//

import Foundation

struct DetailEntity: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let content: String
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        content: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

