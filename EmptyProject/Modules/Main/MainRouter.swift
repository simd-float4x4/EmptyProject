//
//  MainRouter.swift
//  EmptyProject
//
//  Main Module - Router
//

import UIKit
import SwiftUI

final class MainRouter: MainRouterProtocol {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let router = MainRouter()
        
        // DIセットアップ
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let view = MainView(presenter: presenter)
        let hostingController = MainViewController(rootView: view)
        
        presenter.view = hostingController
        router.viewController = hostingController
        
        return hostingController
    }
    
    // MARK: - Navigation
    func navigateToPreview() {
        let previewViewController = PreviewRouter.createModule()
        viewController?.navigationController?.pushViewController(previewViewController, animated: true)
    }
}

