//
//  PresenterProtocol.swift
//  EmptyProject
//
//  VIPER - Presenter Protocol
//

import Foundation
import Combine

/// Presenterプロトコル - ViewとInteractorを仲介する
protocol PresenterProtocol: AnyObject, ObservableObject {
    associatedtype InteractorType
    associatedtype RouterType
    
    var interactor: InteractorType! { get set }
    var router: RouterType! { get set }
    
    /// Viewが読み込まれた時に呼ばれる
    func viewDidLoad()
}

extension PresenterProtocol {
    func viewDidLoad() {}
}
