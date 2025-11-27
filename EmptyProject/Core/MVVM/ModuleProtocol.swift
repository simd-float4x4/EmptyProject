//
//  ModuleProtocol.swift
//  EmptyProject
//
//  MVVM - Module Protocol
//

import UIKit

/// モジュール構築プロトコル
protocol ModuleProtocol {
    static func createModule() -> UIViewController
}

