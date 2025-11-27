//
//  MainPresenter.swift
//  EmptyProject
//
//  Main Module - Presenter
//

import Foundation
import Combine

final class MainPresenter: ObservableObject, MainPresenterProtocol {
    
    // MARK: - Properties
    weak var view: MainViewProtocol?
    var interactor: MainInteractorInputProtocol!
    var router: MainRouterProtocol!
    
    // MARK: - Published Properties
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var isLoading: Bool = false
    
    // MARK: - View -> Presenter
    func viewDidLoad() {
        isLoading = true
        interactor.fetchMainData()
    }
    
    func didTapStartButton() {
        router.navigateToPreview()
    }
}

// MARK: - Interactor Output
extension MainPresenter: MainInteractorOutputProtocol {
    func didFetchMainData(_ entity: MainEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.title = entity.title
            self?.description = entity.description
            self?.isLoading = false
        }
    }
}

