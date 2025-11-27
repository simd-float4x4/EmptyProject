//
//  CameraRouter.swift
//  EmptyProject
//
//  Camera Module - Router
//

import UIKit
import SwiftUI

final class CameraRouter: CameraRouterProtocol {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    weak var presenter: CameraPresenter?
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        let presenter = CameraPresenter()
        let interactor = CameraInteractor()
        let router = CameraRouter()
        
        // DIセットアップ
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        let view = CameraView(presenter: presenter)
        let hostingController = CameraViewController(rootView: view)
        
        presenter.view = hostingController
        router.viewController = hostingController
        
        return hostingController
    }
    
    // MARK: - Navigation
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func presentSettingsModal() {
        guard let presenter = presenter else { return }
        
        let modalVC = CameraModalRouter.createModule(cameraPresenter: presenter)
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        
        viewController?.present(modalVC, animated: true)
    }
}

