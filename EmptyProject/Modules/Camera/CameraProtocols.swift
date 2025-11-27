//
//  CameraProtocols.swift
//  EmptyProject
//
//  Camera Module - Protocols
//

import UIKit
import ARKit

// MARK: - View Protocol
protocol CameraViewProtocol: AnyObject {
    var presenter: CameraPresenterProtocol! { get set }
}

// MARK: - Presenter Protocol
protocol CameraPresenterProtocol: AnyObject {
    var view: CameraViewProtocol? { get set }
    var interactor: CameraInteractorInputProtocol! { get set }
    var router: CameraRouterProtocol! { get set }
    
    // ARKit State
    var arSessionState: ARSessionState { get }
    var trackingStateDescription: String { get }
    var detectedPlanesCount: Int { get }
    
    // View -> Presenter
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didTapBackButton()
    func didTapSettingsButton()
    func didTapCaptureButton()
    func getARSession() -> ARSession
}

// MARK: - Interactor Protocols
protocol CameraInteractorInputProtocol: AnyObject {
    var presenter: CameraInteractorOutputProtocol? { get set }
    var arSession: ARSession { get }
    
    func setupARSession()
    func startARSession()
    func pauseARSession()
    func resetARSession()
    func captureCurrentFrame() -> UIImage?
}

protocol CameraInteractorOutputProtocol: AnyObject {
    func didUpdateARSessionState(_ state: ARSessionState)
    func didUpdateTrackingState(_ state: ARCamera.TrackingState)
    func didDetectPlane(_ anchor: ARPlaneAnchor)
    func didRemovePlane(_ anchor: ARPlaneAnchor)
    func didFailWithError(_ error: Error)
}

// MARK: - Router Protocol
protocol CameraRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func navigateBack()
    func presentSettingsModal()
}

