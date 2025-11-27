//
//  MainView.swift
//  EmptyProject
//
//  Main Module - View
//

import SwiftUI

// MARK: - Main View
struct MainView: View {
    @ObservedObject var presenter: MainPresenter
    
    var body: some View {
        ZStack {
            // 背景グラデーション
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.05, green: 0.05, blue: 0.15)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // アイコン
                Image(systemName: "arkit")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .cyan.opacity(0.5), radius: 20)
                
                // タイトル
                VStack(spacing: 12) {
                    Text(presenter.title)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(presenter.description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // スタートボタン
                Button(action: {
                    presenter.didTapStartButton()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 20))
                        Text("カメラを開始")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .cyan.opacity(0.4), radius: 10, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
            
            // ローディング
            if presenter.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            presenter.viewDidLoad()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - View Controller
final class MainViewController: UIHostingController<MainView>, MainViewProtocol {
    var presenter: MainPresenterProtocol!
}

