//
//  HomeController.swift
//  EmptyProject
//
//  Home Module Controller
//

import Foundation
import Combine

final class HomeController: ControllerProtocol, ObservableObject {
    @Published var items: [HomeEntity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    var navigateToDetailHandler: ((HomeEntity) -> Void)?
    
    func viewDidLoad() {
        fetchItems()
    }
    
    func viewWillDisappear() {
        cancellables.removeAll()
    }
    
    private func fetchItems() {
        isLoading = true
        errorMessage = nil
        
        // サンプルデータを生成
        let sampleItems: [HomeEntity] = [
            HomeEntity(
                title: "はじめてのMVC",
                description: "SwiftUIとMVCアーキテクチャを組み合わせたサンプルプロジェクトです。"
            ),
            HomeEntity(
                title: "画面遷移について",
                description: "UIHostingControllerを使用して、UIKitベースの画面遷移を実現しています。"
            ),
            HomeEntity(
                title: "モジュール構成",
                description: "各画面はView, Controller, Model, Routerで構成されています。"
            ),
            HomeEntity(
                title: "コード生成",
                description: "ターミナルコマンドで新しいモジュールを自動生成できます。"
            )
        ]
        
        // 非同期処理をシミュレート
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.items = sampleItems
            }
        }
    }
    
    func navigateToDetail(with item: HomeEntity) {
        navigateToDetailHandler?(item)
    }
}

