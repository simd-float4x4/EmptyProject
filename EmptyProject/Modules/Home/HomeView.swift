//
//  HomeView.swift
//  EmptyProject
//
//  Home Module View
//

import SwiftUI
import UIKit

// MARK: - SwiftUI View
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        List(viewModel.items) { item in
            HomeItemRow(item: item) {
                viewModel.navigateToDetail(with: item)
            }
        }
        .navigationTitle("Home")
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

// MARK: - Item Row
struct HomeItemRow: View {
    let item: HomeEntity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - UIHostingController
final class HomeViewController: UIHostingController<HomeView> {
    let viewModel: HomeViewModel
    let router: HomeRouter
    
    init(viewModel: HomeViewModel, router: HomeRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(rootView: HomeView(viewModel: viewModel))
        self.router.viewController = self
        
        // ViewModelのナビゲーションハンドラを設定
        viewModel.navigateToDetailHandler = { [weak router] item in
            router?.navigateToDetail(with: item)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
