//
//  MainInteractor.swift
//  EmptyProject
//
//  Main Module - Interactor
//

import Foundation

final class MainInteractor: MainInteractorInputProtocol {
    
    // MARK: - Properties
    weak var presenter: MainInteractorOutputProtocol?
    
    // MARK: - Methods
    func fetchMainData() {
        // 実際のアプリではここでAPIコールなどを行う
        let entity = MainEntity.default
        presenter?.didFetchMainData(entity)
    }
}

