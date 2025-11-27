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
    @ObservedObject var presenter: HomePresenter
    
    var body: some View {
        List(presenter.items) { item in
            HomeItemRow(item: item) {
                presenter.navigateToDetail(with: item)
            }
        }
        .navigationTitle("Home")
        .onAppear {
            presenter.viewDidLoad()
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
final class HomeViewController: UIHostingController<HomeView>, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(rootView: HomeView(presenter: presenter))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

