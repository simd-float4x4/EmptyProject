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
    @ObservedObject var controller: DetailController
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = controller.detail {
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
                } else if controller.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = controller.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            controller.viewDidLoad()
        }
        .onDisappear {
            controller.viewWillDisappear()
        }
    }
}

// MARK: - UIHostingController
final class DetailViewController: UIHostingController<DetailView> {
    let controller: DetailController
    let router: DetailRouter
    
    init(controller: DetailController, router: DetailRouter) {
        self.controller = controller
        self.router = router
        super.init(rootView: DetailView(controller: controller))
        self.router.viewController = self
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
