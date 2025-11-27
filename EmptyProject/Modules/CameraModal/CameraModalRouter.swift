//
//  CameraModalRouter.swift
//  EmptyProject
//
//  CameraModal Module - Router
//

import UIKit
import SwiftUI

final class CameraModalRouter: CameraModalRouterProtocol {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    static func createModule(cameraPresenter: CameraPresenter? = nil) -> UIViewController {
        let presenter = CameraModalPresenter()
        let interactor = CameraModalInteractor()
        let router = CameraModalRouter()
        
        // DIセットアップ
        presenter.interactor = interactor
        presenter.router = router
        presenter.cameraPresenter = cameraPresenter
        interactor.presenter = presenter
        
        let view = CameraModalView(presenter: presenter)
        let hostingController = CameraModalViewController(rootView: view)
        
        presenter.view = hostingController
        router.viewController = hostingController
        
        return hostingController
    }
    
    // MARK: - Navigation
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

