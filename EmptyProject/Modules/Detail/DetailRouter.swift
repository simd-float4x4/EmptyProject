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
        let viewModel = DetailViewModel(item: item)
        let router = DetailRouter()
        let view = DetailViewController(viewModel: viewModel, router: router)
        return view
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
