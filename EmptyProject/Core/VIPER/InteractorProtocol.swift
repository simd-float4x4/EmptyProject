//
//  InteractorProtocol.swift
//  EmptyProject
//
//  VIPER - Interactor Protocol
//

import Foundation

/// Interactor入力プロトコル - Presenterからの要求を受け取る
protocol InteractorInputProtocol: AnyObject {
    associatedtype PresenterType
    var presenter: PresenterType? { get set }
}

/// Interactor出力プロトコル - Presenterへ結果を返す
protocol InteractorOutputProtocol: AnyObject {
}

