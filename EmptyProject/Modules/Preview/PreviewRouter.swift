//
//  PreviewRouter.swift
//  EmptyProject
//
//  Preview Module - Router
//

import UIKit
import SwiftUI

final class PreviewRouter: PreviewRouterProtocol {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        let presenter = PreviewPresenter()
        let interactor = PreviewInteractor()
        let router = PreviewRouter()
        
        // DIセットアップ
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        let view = PreviewView(presenter: presenter)
        let hostingController = PreviewViewController(rootView: view)
        
        presenter.view = hostingController
        router.viewController = hostingController
        
        return hostingController
    }
    
    // MARK: - Navigation
    func navigateToCamera() {
        let cameraViewController = CameraRouter.createModule()
        viewController?.navigationController?.pushViewController(cameraViewController, animated: true)
    }
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

