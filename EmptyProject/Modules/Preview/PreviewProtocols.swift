//
//  PreviewProtocols.swift
//  EmptyProject
//
//  Preview Module - Protocols
//

import UIKit
import AVFoundation

// MARK: - View Protocol
protocol PreviewViewProtocol: AnyObject {
    var presenter: PreviewPresenterProtocol! { get set }
}

// MARK: - Presenter Protocol
protocol PreviewPresenterProtocol: AnyObject {
    var view: PreviewViewProtocol? { get set }
    var interactor: PreviewInteractorInputProtocol! { get set }
    var router: PreviewRouterProtocol! { get set }
    
    // View -> Presenter
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didTapStartARButton()
    func didTapSwitchCameraButton()
    func didTapBackButton()
}

// MARK: - Interactor Protocols
protocol PreviewInteractorInputProtocol: AnyObject {
    var presenter: PreviewInteractorOutputProtocol? { get set }
    var captureSession: AVCaptureSession? { get }
    
    func requestCameraPermission()
    func setupCameraSession()
    func startCameraSession()
    func stopCameraSession()
    func switchCamera()
}

protocol PreviewInteractorOutputProtocol: AnyObject {
    func didUpdateCameraPermission(_ status: AVAuthorizationStatus)
    func didSetupCameraSession(_ session: AVCaptureSession)
    func didFailToSetupCamera(_ error: Error)
    func didSwitchCamera(to position: AVCaptureDevice.Position)
}

// MARK: - Router Protocol
protocol PreviewRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func navigateToCamera()
    func navigateBack()
}

