//
//  DetailView.swift
//  EmptyProject
//
//  Detail Module View
//

import SwiftUI
import UIKit

// MARK: - SwiftUI View
struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = viewModel.detail {
                    Text(detail.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(detail.description)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text(detail.content)
                        .font(.body)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("作成日: \(detail.createdAt.formatted())")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("更新日: \(detail.updatedAt.formatted())")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

// MARK: - UIHostingController
final class DetailViewController: UIHostingController<DetailView> {
    let viewModel: DetailViewModel
    let router: DetailRouter
    
    init(viewModel: DetailViewModel, router: DetailRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(rootView: DetailView(viewModel: viewModel))
        self.router.viewController = self
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
