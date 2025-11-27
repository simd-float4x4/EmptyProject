//
//  ViewModelProtocol.swift
//  EmptyProject
//
//  MVVM - ViewModel Protocol
//

import Foundation
import Combine

/// ViewModelプロトコル - ViewとModelを仲介する
protocol ViewModelProtocol: AnyObject, ObservableObject {
    /// ViewModelの初期化
    func onAppear()
    /// ViewModelの破棄
    func onDisappear()
}

extension ViewModelProtocol {
    func onAppear() {}
    func onDisappear() {}
}

