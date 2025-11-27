//
//  DetailRouter.swift
//  EmptyProject
//
//  Detail Module Router
//

import UIKit

final class DetailRouter: DetailRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule(with item: HomeEntity) -> UIViewController {
        let presenter = DetailPresenter(item: item)
        let interactor = DetailInteractor()
        let router = DetailRouter()
        
        let view = DetailViewController(presenter: presenter)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

