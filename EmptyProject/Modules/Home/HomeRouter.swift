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
        let controller = HomeController()
        let router = HomeRouter()
        let view = HomeViewController(controller: controller, router: router)
        return view
    }
    
    func navigateToDetail(with item: HomeEntity) {
        let detailViewController = DetailRouter.createModule(with: item)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
