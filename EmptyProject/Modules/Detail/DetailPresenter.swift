//
//  DetailPresenter.swift
//  EmptyProject
//
//  Detail Module Presenter
//

import Foundation

final class DetailPresenter: DetailPresenterProtocol, ObservableObject {
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorInputProtocol!
    var router: DetailRouterProtocol!
    
    @Published var detail: DetailEntity?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let item: HomeEntity
    
    init(item: HomeEntity) {
        self.item = item
    }
    
    func viewDidLoad() {
        isLoading = true
        interactor.fetchDetail(for: item)
    }
    
    func goBack() {
        router.goBack()
    }
}

// MARK: - Interactor Output
extension DetailPresenter: DetailInteractorOutputProtocol {
    func didFetchDetail(_ detail: DetailEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.detail = detail
        }
    }
    
    func didFailFetchingDetail(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.errorMessage = error.localizedDescription
        }
    }
}

