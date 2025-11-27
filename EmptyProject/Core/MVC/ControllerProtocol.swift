//
//  ControllerProtocol.swift
//  EmptyProject
//
//  MVC - Controller Protocol
//

import Foundation
import Combine

/// Controllerプロトコル - ViewとModelを仲介する
protocol ControllerProtocol: AnyObject, ObservableObject {
    /// Controllerの初期化
    func viewDidLoad()
    /// Controllerの破棄
    func viewWillDisappear()
}

extension ControllerProtocol {
    func viewDidLoad() {}
    func viewWillDisappear() {}
}

