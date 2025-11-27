//
//  HomeRouter.swift
//  EmptyProject
//
//  Home Module Router
//

import UIKit

final class HomeRouter: HomeRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        
        let view = HomeViewController(presenter: presenter)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToDetail(with item: HomeEntity) {
        let detailViewController = DetailRouter.createModule(with: item)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

