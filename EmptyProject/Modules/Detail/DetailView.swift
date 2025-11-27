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
    @ObservedObject var presenter: DetailPresenter
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = presenter.detail {
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
                } else if presenter.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = presenter.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            presenter.viewDidLoad()
        }
    }
}

// MARK: - UIHostingController
final class DetailViewController: UIHostingController<DetailView>, DetailViewProtocol {
    var presenter: DetailPresenterProtocol!
    
    init(presenter: DetailPresenter) {
        self.presenter = presenter
        super.init(rootView: DetailView(presenter: presenter))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

