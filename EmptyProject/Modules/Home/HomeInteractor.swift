//
//  HomeInteractor.swift
//  EmptyProject
//
//  Home Module Interactor
//

import Foundation

final class HomeInteractor: HomeInteractorInputProtocol {
    weak var presenter: HomeInteractorOutputProtocol?
    
    func fetchItems() {
        // サンプルデータを生成
        let sampleItems: [HomeEntity] = [
            HomeEntity(
                title: "はじめてのVIPER",
                description: "SwiftUIとVIPERアーキテクチャを組み合わせたサンプルプロジェクトです。"
            ),
            HomeEntity(
                title: "画面遷移について",
                description: "UIHostingControllerを使用して、UIKitベースの画面遷移を実現しています。"
            ),
            HomeEntity(
                title: "モジュール構成",
                description: "各画面はView, Interactor, Presenter, Entity, Routerで構成されています。"
            ),
            HomeEntity(
                title: "コード生成",
                description: "ターミナルコマンドで新しいモジュールを自動生成できます。"
            )
        ]
        
        // 非同期処理をシミュレート
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.presenter?.didFetchItems(sampleItems)
        }
    }
}

