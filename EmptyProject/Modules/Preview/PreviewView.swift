//
//  PreviewView.swift
//  EmptyProject
//
//  Preview Module - View
//

import SwiftUI
import AVFoundation

// MARK: - Preview View
struct PreviewView: View {
    @ObservedObject var presenter: PreviewPresenter
    
    var body: some View {
        ZStack {
            // カメラプレビュー
            if let session = presenter.captureSession {
                CameraPreviewView(session: session)
                    .ignoresSafeArea()
            } else {
                Color.black
                    .ignoresSafeArea()
            }
            
            // オーバーレイUI
            VStack {
                // ヘッダー
                HStack {
                    Button(action: {
                        presenter.didTapBackButton()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("カメラプレビュー")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        presenter.didTapSwitchCameraButton()
                    }) {
                        Image(systemName: "camera.rotate")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                // フッター
                VStack(spacing: 20) {
                    // カメラ位置表示
                    Text(presenter.currentCameraPosition == .back ? "背面カメラ" : "前面カメラ")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(20)
                    
                    // ARKit開始ボタン
                    Button(action: {
                        presenter.didTapStartARButton()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arkit")
                                .font(.system(size: 24))
                            Text("ARKitを開始")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .orange.opacity(0.4), radius: 10, y: 5)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 50)
            }
            
            // エラーメッセージ
            if let errorMessage = presenter.errorMessage {
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.bottom, 150)
                    Spacer()
                }
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
        .onDisappear {
            presenter.viewWillDisappear()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Camera Preview View (UIViewRepresentable)
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.session = session
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        uiView.session = session
    }
}

class CameraPreviewUIView: UIView {
    var session: AVCaptureSession? {
        didSet {
            if let session = session {
                previewLayer.session = session
            }
        }
    }
    
    private var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        previewLayer.videoGravity = .resizeAspectFill
    }
}

// MARK: - View Controller
final class PreviewViewController: UIHostingController<PreviewView>, PreviewViewProtocol {
    var presenter: PreviewPresenterProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
}

