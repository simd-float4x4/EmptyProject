//
//  CameraView.swift
//  EmptyProject
//
//  Camera Module - View
//

import SwiftUI
import ARKit

// MARK: - Camera View
struct CameraView: View {
    @ObservedObject var presenter: CameraPresenter
    
    var body: some View {
        ZStack {
            // ARKitビュー
            ARViewContainer(session: presenter.getARSession())
                .ignoresSafeArea()
            
            // オーバーレイUI
            VStack {
                // ヘッダー
                headerView
                
                Spacer()
                
                // フッター
                footerView
            }
            
            // エラーメッセージ
            if let errorMessage = presenter.errorMessage {
                errorView(message: errorMessage)
            }
            
            // ローディング
            if presenter.isLoading {
                loadingView
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
    
    // MARK: - Header View
    private var headerView: some View {
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
            
            // ステータス表示
            VStack(spacing: 4) {
                Text(presenter.trackingStateDescription)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Text("検出平面: \(presenter.detectedPlanesCount)")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
            
            Spacer()
            
            Button(action: {
                presenter.didTapSettingsButton()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - Footer View
    private var footerView: some View {
        VStack(spacing: 20) {
            // キャプチャボタン
            Button(action: {
                presenter.didTapCaptureButton()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 80, height: 80)
                }
            }
            .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
        }
        .padding(.bottom, 50)
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding()
                .background(Color.red.opacity(0.8))
                .cornerRadius(8)
                .padding(.bottom, 150)
            Spacer()
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("ARKitを初期化中...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - AR View Container (UIViewRepresentable)
struct ARViewContainer: UIViewRepresentable {
    let session: ARSession
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.session = session
        arView.automaticallyUpdatesLighting = true
        arView.delegate = context.coordinator
        
        // デバッグオプション
        #if DEBUG
        arView.debugOptions = [.showFeaturePoints]
        #endif
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // セッションの更新があれば反映
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // 平面のビジュアライゼーション
            let plane = SCNPlane(
                width: CGFloat(planeAnchor.planeExtent.width),
                height: CGFloat(planeAnchor.planeExtent.height)
            )
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.cyan.withAlphaComponent(0.3)
            plane.materials = [material]
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3(
                planeAnchor.center.x,
                0,
                planeAnchor.center.z
            )
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor,
                  let planeNode = node.childNodes.first,
                  let plane = planeNode.geometry as? SCNPlane else { return }
            
            plane.width = CGFloat(planeAnchor.planeExtent.width)
            plane.height = CGFloat(planeAnchor.planeExtent.height)
            planeNode.position = SCNVector3(
                planeAnchor.center.x,
                0,
                planeAnchor.center.z
            )
        }
    }
}

// MARK: - View Controller
final class CameraViewController: UIHostingController<CameraView>, CameraViewProtocol {
    var presenter: CameraPresenterProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
}

