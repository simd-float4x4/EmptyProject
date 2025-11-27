//
//  HomeRouter.swift
//  EmptyProject
//
//  Home Module Router
//

import UIKit

final class HomeRouter: RouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let viewModel = HomeViewModel()
        let router = HomeRouter()
        let view = HomeViewController(viewModel: viewModel, router: router)
        return view
    }
    
    func navigateToDetail(with item: HomeEntity) {
        let detailViewController = DetailRouter.createModule(with: item)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
