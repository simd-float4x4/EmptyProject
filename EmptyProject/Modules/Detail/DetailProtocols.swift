//
//  DetailProtocols.swift
//  EmptyProject
//
//  Detail Module Protocols
//

import UIKit

// MARK: - View Protocol
protocol DetailViewProtocol: AnyObject {
    var presenter: DetailPresenterProtocol! { get set }
}

// MARK: - Presenter Protocol
protocol DetailPresenterProtocol: AnyObject, ObservableObject {
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorInputProtocol! { get set }
    var router: DetailRouterProtocol! { get set }
    
    func viewDidLoad()
    func goBack()
}

// MARK: - Interactor Protocol
protocol DetailInteractorInputProtocol: AnyObject {
    var presenter: DetailInteractorOutputProtocol? { get set }
    
    func fetchDetail(for item: HomeEntity)
}

protocol DetailInteractorOutputProtocol: AnyObject {
    func didFetchDetail(_ detail: DetailEntity)
    func didFailFetchingDetail(with error: Error)
}

// MARK: - Router Protocol
protocol DetailRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule(with item: HomeEntity) -> UIViewController
    func goBack()
}

