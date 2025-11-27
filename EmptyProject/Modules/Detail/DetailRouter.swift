//
//  DetailRouter.swift
//  EmptyProject
//
//  Detail Module Router
//

import UIKit

final class DetailRouter: RouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule(with item: HomeEntity) -> UIViewController {
        let controller = DetailController(item: item)
        let router = DetailRouter()
        let view = DetailViewController(controller: controller, router: router)
        return view
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
