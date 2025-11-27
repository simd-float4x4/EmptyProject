//
//  ViewProtocol.swift
//  EmptyProject
//
//  VIPER - View Protocol
//

import SwiftUI

/// Viewプロトコル - Presenterからの更新を受け取る
protocol ViewProtocol: AnyObject {
    associatedtype PresenterType
    var presenter: PresenterType! { get set }
}

