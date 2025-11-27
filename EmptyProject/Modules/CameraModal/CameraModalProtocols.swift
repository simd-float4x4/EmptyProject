//
//  CameraModalProtocols.swift
//  EmptyProject
//
//  CameraModal Module - Protocols
//

import UIKit

// MARK: - View Protocol
protocol CameraModalViewProtocol: AnyObject {
    var presenter: CameraModalPresenterProtocol! { get set }
}

// MARK: - Presenter Protocol
protocol CameraModalPresenterProtocol: AnyObject {
    var view: CameraModalViewProtocol? { get set }
    var interactor: CameraModalInteractorInputProtocol! { get set }
    var router: CameraModalRouterProtocol! { get set }
    
    // State
    var settings: CameraModalEntity { get }
    
    // View -> Presenter
    func viewDidLoad()
    func didTogglePlaneDetection(_ isEnabled: Bool)
    func didToggleLightEstimation(_ isEnabled: Bool)
    func didToggleDebugMode(_ isEnabled: Bool)
    func didSelectQuality(_ quality: VideoQuality)
    func didTapResetButton()
    func didTapCloseButton()
    func didTapApplyButton()
}

// MARK: - Interactor Protocols
protocol CameraModalInteractorInputProtocol: AnyObject {
    var presenter: CameraModalInteractorOutputProtocol? { get set }
    
    func fetchCurrentSettings()
    func saveSettings(_ settings: CameraModalEntity)
    func resetSettings()
}

protocol CameraModalInteractorOutputProtocol: AnyObject {
    func didFetchSettings(_ settings: CameraModalEntity)
    func didSaveSettings()
    func didResetSettings(_ settings: CameraModalEntity)
}

// MARK: - Router Protocol
protocol CameraModalRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule(cameraPresenter: CameraPresenter?) -> UIViewController
    func dismiss()
}

