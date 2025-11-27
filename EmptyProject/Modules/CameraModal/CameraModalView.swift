//
//  CameraModalView.swift
//  EmptyProject
//
//  CameraModal Module - View
//

import SwiftUI

// MARK: - Camera Modal View
struct CameraModalView: View {
    @ObservedObject var presenter: CameraModalPresenter
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // AR設定セクション
                        settingsSection(title: "AR設定", icon: "arkit") {
                            toggleRow(
                                title: "平面検出",
                                subtitle: "水平・垂直面を検出",
                                icon: "square.stack.3d.up",
                                isOn: Binding(
                                    get: { presenter.settings.planeDetectionEnabled },
                                    set: { presenter.didTogglePlaneDetection($0) }
                                )
                            )
                            
                            Divider()
                            
                            toggleRow(
                                title: "光量推定",
                                subtitle: "環境光を自動調整",
                                icon: "sun.max",
                                isOn: Binding(
                                    get: { presenter.settings.lightEstimationEnabled },
                                    set: { presenter.didToggleLightEstimation($0) }
                                )
                            )
                        }
                        
                        // 画質設定セクション
                        settingsSection(title: "画質設定", icon: "video") {
                            ForEach(VideoQuality.allCases) { quality in
                                qualityRow(quality: quality)
                                
                                if quality != VideoQuality.allCases.last {
                                    Divider()
                                }
                            }
                        }
                        
                        // デバッグセクション
                        settingsSection(title: "デバッグ", icon: "ladybug") {
                            toggleRow(
                                title: "デバッグモード",
                                subtitle: "特徴点を表示",
                                icon: "point.3.filled.connected.trianglepath.dotted",
                                isOn: Binding(
                                    get: { presenter.settings.debugModeEnabled },
                                    set: { presenter.didToggleDebugMode($0) }
                                )
                            )
                        }
                        
                        // リセットボタン
                        Button(action: {
                            presenter.didTapResetButton()
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("設定をリセット")
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 20)
                }
                
                // ローディング
                if presenter.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("閉じる") {
                        presenter.didTapCloseButton()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("適用") {
                        presenter.didTapApplyButton()
                    }
                    .fontWeight(.semibold)
                    .disabled(!presenter.hasChanges)
                }
            }
        }
        .onAppear {
            presenter.viewDidLoad()
        }
    }
    
    // MARK: - Settings Section
    private func settingsSection<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.orange)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Toggle Row
    private func toggleRow(
        title: String,
        subtitle: String,
        icon: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.orange)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.orange)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Quality Row
    private func qualityRow(quality: VideoQuality) -> some View {
        Button(action: {
            presenter.didSelectQuality(quality)
        }) {
            HStack(spacing: 16) {
                Image(systemName: qualityIcon(for: quality))
                    .font(.system(size: 20))
                    .foregroundColor(.orange)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(quality.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(quality.description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if presenter.settings.selectedQuality == quality {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.orange)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func qualityIcon(for quality: VideoQuality) -> String {
        switch quality {
        case .low: return "antenna.radiowaves.left.and.right"
        case .medium: return "chart.bar.fill"
        case .high: return "chart.bar.xaxis"
        case .ultra: return "sparkles"
        }
    }
}

// MARK: - View Controller
final class CameraModalViewController: UIHostingController<CameraModalView>, CameraModalViewProtocol {
    var presenter: CameraModalPresenterProtocol!
}

