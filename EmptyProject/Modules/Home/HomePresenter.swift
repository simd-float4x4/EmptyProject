//
//  HomePresenter.swift
//  EmptyProject
//
//  Home Module Presenter
//

import Foundation
import Combine

final class HomePresenter: HomePresenterProtocol, ObservableObject {
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol!
    var router: HomeRouterProtocol!
    
    @Published var items: [HomeEntity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func viewDidLoad() {
        isLoading = true
        interactor.fetchItems()
    }
    
    func navigateToDetail(with item: HomeEntity) {
        router.navigateToDetail(with: item)
    }
}

// MARK: - Interactor Output
extension HomePresenter: HomeInteractorOutputProtocol {
    func didFetchItems(_ items: [HomeEntity]) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.items = items
        }
    }
    
    func didFailFetchingItems(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.errorMessage = error.localizedDescription
        }
    }
}

