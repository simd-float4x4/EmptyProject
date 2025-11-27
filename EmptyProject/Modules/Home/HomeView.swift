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
    @ObservedObject var controller: HomeController
    
    var body: some View {
        List(controller.items) { item in
            HomeItemRow(item: item) {
                controller.navigateToDetail(with: item)
            }
        }
        .navigationTitle("Home")
        .onAppear {
            controller.viewDidLoad()
        }
        .onDisappear {
            controller.viewWillDisappear()
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
    let controller: HomeController
    let router: HomeRouter
    
    init(controller: HomeController, router: HomeRouter) {
        self.controller = controller
        self.router = router
        super.init(rootView: HomeView(controller: controller))
        self.router.viewController = self
        
        // Controllerのナビゲーションハンドラを設定
        controller.navigateToDetailHandler = { [weak router] item in
            router?.navigateToDetail(with: item)
        }
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
