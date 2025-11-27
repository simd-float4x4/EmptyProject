//
//  DetailController.swift
//  EmptyProject
//
//  Detail Module Controller
//

import Foundation
import Combine

final class DetailController: ControllerProtocol, ObservableObject {
    @Published var detail: DetailEntity?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let item: HomeEntity
    
    init(item: HomeEntity) {
        self.item = item
    }
    
    func viewDidLoad() {
        fetchDetail()
    }
    
    func viewWillDisappear() {
        cancellables.removeAll()
    }
    
    private func fetchDetail() {
        isLoading = true
        errorMessage = nil
        
        // サンプル詳細データを生成
        let detailContent = """
        これは「\(item.title)」の詳細ページです。
        
        MVCアーキテクチャでは、各画面がモジュールとして独立しており、以下のコンポーネントで構成されています：
        
        • View: UI表示を担当（SwiftUI View + UIHostingController）
        • Controller: ViewとModelの仲介を担当、ビジネスロジックを処理
        • Model: データモデルを定義
        • Router: 画面遷移を担当
        
        この構造により、各コンポーネントの責務が明確になり、テストしやすく保守性の高いコードを実現できます。
        """
        
        let detail = DetailEntity(
            id: item.id,
            title: item.title,
            description: item.description,
            content: detailContent
        )
        
        // 非同期処理をシミュレート
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.detail = detail
            }
        }
    }
}

