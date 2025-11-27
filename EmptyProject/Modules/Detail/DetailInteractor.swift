//
//  DetailInteractor.swift
//  EmptyProject
//
//  Detail Module Interactor
//

import Foundation

final class DetailInteractor: DetailInteractorInputProtocol {
    weak var presenter: DetailInteractorOutputProtocol?
    
    func fetchDetail(for item: HomeEntity) {
        // サンプル詳細データを生成
        let detailContent = """
        これは「\(item.title)」の詳細ページです。
        
        VIPERアーキテクチャでは、各画面がモジュールとして独立しており、以下のコンポーネントで構成されています：
        
        • View: UI表示を担当（SwiftUI View + UIHostingController）
        • Interactor: ビジネスロジックを担当
        • Presenter: ViewとInteractorの仲介を担当
        • Entity: データモデルを定義
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
            self?.presenter?.didFetchDetail(detail)
        }
    }
}

