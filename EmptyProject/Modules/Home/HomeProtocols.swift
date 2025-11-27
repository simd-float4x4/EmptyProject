//
//  HomeProtocols.swift
//  EmptyProject
//
//  Home Module Protocols
//

import UIKit

// MARK: - View Protocol
protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol! { get set }
}

// MARK: - Presenter Protocol
protocol HomePresenterProtocol: AnyObject, ObservableObject {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol! { get set }
    var router: HomeRouterProtocol! { get set }
    
    func viewDidLoad()
    func navigateToDetail(with item: HomeEntity)
}

// MARK: - Interactor Protocol
protocol HomeInteractorInputProtocol: AnyObject {
    var presenter: HomeInteractorOutputProtocol? { get set }
    
    func fetchItems()
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func didFetchItems(_ items: [HomeEntity])
    func didFailFetchingItems(with error: Error)
}

// MARK: - Router Protocol
protocol HomeRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func navigateToDetail(with item: HomeEntity)
}

