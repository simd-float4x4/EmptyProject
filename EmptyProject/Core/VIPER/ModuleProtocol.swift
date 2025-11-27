//
//  ModuleProtocol.swift
//  EmptyProject
//
//  VIPER - Module Protocol
//

import UIKit

/// モジュール構築プロトコル
protocol ModuleProtocol {
    static func createModule() -> UIViewController
}
