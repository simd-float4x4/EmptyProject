# EmptyProject - SwiftUI ARKit Demo

SwiftUIとVIPERアーキテクチャを使用したARKitデモアプリケーションです。

## 📱 画面構成

| 画面 | 説明 |
|------|------|
| Main | メイン画面 - アプリのエントリーポイント |
| Preview | カメラプレビュー画面 - AVFoundationによるカメラプレビュー |
| Camera | ARKit画面 - ARWorldTrackingによる平面検出 |
| CameraModal | 設定モーダル - AR設定のカスタマイズ |

## 🏗 アーキテクチャ

VIPERアーキテクチャを採用しています。

```
┌─────────────────────────────────────────────────────────┐
│                       Module                            │
├─────────┬─────────┬─────────┬─────────┬────────────────┤
│  View   │Presenter│Interactor│ Router │    Entity      │
│         │         │          │        │                │
│ SwiftUI │ビジネス │ データ層  │ 画面遷移│ データモデル    │
│   UI    │ ロジック │          │        │                │
└─────────┴─────────┴──────────┴────────┴────────────────┘
```

### 各コンポーネントの役割

- **View**: SwiftUIによるUI表示（UIHostingController経由）
- **Presenter**: ViewとInteractorの仲介、ビジネスロジック
- **Interactor**: データ取得・処理、外部サービスとの通信
- **Router**: 画面遷移の管理
- **Entity**: データモデル定義

## 📁 プロジェクト構造

```
EmptyProject/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Core/
│   └── VIPER/
│       ├── ViewProtocol.swift
│       ├── PresenterProtocol.swift
│       ├── InteractorProtocol.swift
│       ├── RouterProtocol.swift
│       └── ModuleProtocol.swift
└── Modules/
    ├── Main/
    │   ├── MainEntity.swift
    │   ├── MainProtocols.swift
    │   ├── MainPresenter.swift
    │   ├── MainInteractor.swift
    │   ├── MainRouter.swift
    │   └── MainView.swift
    ├── Preview/
    │   ├── PreviewEntity.swift
    │   ├── PreviewProtocols.swift
    │   ├── PreviewPresenter.swift
    │   ├── PreviewInteractor.swift
    │   ├── PreviewRouter.swift
    │   └── PreviewView.swift
    ├── Camera/
    │   ├── CameraEntity.swift
    │   ├── CameraProtocols.swift
    │   ├── CameraPresenter.swift
    │   ├── CameraInteractor.swift
    │   ├── CameraRouter.swift
    │   └── CameraView.swift
    └── CameraModal/
        ├── CameraModalEntity.swift
        ├── CameraModalProtocols.swift
        ├── CameraModalPresenter.swift
        ├── CameraModalInteractor.swift
        ├── CameraModalRouter.swift
        └── CameraModalView.swift
```

## 🔧 技術スタック

- **UI**: SwiftUI + UIKit (UIHostingController)
- **Architecture**: VIPER
- **Camera**: AVFoundation
- **AR**: ARKit + SceneKit
- **State Management**: Combine (@Published, @ObservedObject)

## 📋 必要な権限

Info.plist（自動生成）に以下の権限が必要です。Build Settingsで設定してください：

```
INFOPLIST_KEY_NSCameraUsageDescription = "カメラを使用してAR体験を提供します";
```

または、Xcode > Target > Info > Custom iOS Target Properties に追加：

| Key | Value |
|-----|-------|
| Privacy - Camera Usage Description | カメラを使用してAR体験を提供します |

## 🚀 画面遷移フロー

```
Main → Preview → Camera
                    ↓
              CameraModal (Sheet)
```

1. **Main** → 「カメラを開始」ボタンで Preview へ遷移
2. **Preview** → 「ARKitを開始」ボタンで Camera へ遷移
3. **Camera** → 設定アイコンで CameraModal をシート表示

## 🎨 UI特徴

- ダークテーマベースのモダンUI
- グラデーションとシャドウを活用したビジュアル
- iOS 15以降のネイティブシート機能（UISheetPresentationController）
- AR平面検出のリアルタイム可視化

## 📝 設定項目（CameraModal）

| 設定 | 説明 |
|------|------|
| 平面検出 | 水平・垂直面の検出ON/OFF |
| 光量推定 | 環境光の自動調整ON/OFF |
| 画質設定 | 低/中/高/最高から選択 |
| デバッグモード | 特徴点の表示ON/OFF |

## 💡 画面遷移の実装方式

`.navigationSheet`ではなく、`UIHostingController`とUIKitのナビゲーションを使用しています。

```swift
// Router での画面遷移例
func navigateToCamera() {
    let cameraViewController = CameraRouter.createModule()
    viewController?.navigationController?.pushViewController(cameraViewController, animated: true)
}
```

## 📱 動作環境

- iOS 15.0+
- Xcode 15.0+
- ARKit対応デバイス（シミュレータではAR機能は制限されます）

## 📄 ライセンス

MIT License
