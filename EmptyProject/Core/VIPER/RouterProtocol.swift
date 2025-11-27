//
//  RouterProtocol.swift
//  EmptyProject
//
//  VIPER - Router Protocol
//

import UIKit
import SwiftUI

/// Routerプロトコル - 画面遷移を担当する
protocol RouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
}

extension RouterProtocol {
    /// Push遷移
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.viewController?.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /// Pop遷移
    func pop(animated: Bool = true) {
        self.viewController?.navigationController?.popViewController(animated: animated)
    }
    
    /// Modal表示
    func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.viewController?.present(viewController, animated: animated, completion: completion)
    }
    
    /// Modal閉じる
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.viewController?.dismiss(animated: animated, completion: completion)
    }
    
    /// ルートに戻る
    func popToRoot(animated: Bool = true) {
        self.viewController?.navigationController?.popToRootViewController(animated: animated)
    }
}
