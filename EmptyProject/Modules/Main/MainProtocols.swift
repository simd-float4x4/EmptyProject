//
//  MainProtocols.swift
//  EmptyProject
//
//  Main Module - Protocols
//

import UIKit

// MARK: - View Protocol
protocol MainViewProtocol: AnyObject {
    var presenter: MainPresenterProtocol! { get set }
}

// MARK: - Presenter Protocol
protocol MainPresenterProtocol: AnyObject {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorInputProtocol! { get set }
    var router: MainRouterProtocol! { get set }
    
    // View -> Presenter
    func viewDidLoad()
    func didTapStartButton()
}

// MARK: - Interactor Protocols
protocol MainInteractorInputProtocol: AnyObject {
    var presenter: MainInteractorOutputProtocol? { get set }
    
    func fetchMainData()
}

protocol MainInteractorOutputProtocol: AnyObject {
    func didFetchMainData(_ entity: MainEntity)
}

// MARK: - Router Protocol
protocol MainRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func navigateToPreview()
}

