# SwiftUI MVVM Template

SwiftUIとMVVMアーキテクチャを組み合わせたiOSアプリのテンプレートリポジトリです。

## アーキテクチャ概要

このテンプレートは、UIHostingControllerを使用したモジュールベースの画面遷移を採用しています。

```
┌─────────────────────────────────────────────────────────────┐
│                         Module                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────┐    ┌────────────┐    ┌─────────┐              │
│  │  View   │◄──►│ ViewModel  │◄──►│  Model  │              │
│  └─────────┘    └────────────┘    └─────────┘              │
│       │              │                  │                   │
│       │              │                  │                   │
│       ▼              ▼                  ▼                   │
│  ┌─────────┐    ┌─────────┐       ┌─────────┐              │
│  │ UIHost- │    │ Router  │       │ Entity  │              │
│  │ ing     │    └─────────┘       └─────────┘              │
│  │Controller│                                               │
│  └─────────┘                                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 各コンポーネントの役割

| コンポーネント | 役割 |
|---------------|------|
| **View** | SwiftUI Viewを使用したUI表示。UIHostingControllerでラップ |
| **ViewModel** | ViewとModelの仲介。ビジネスロジックの処理。ObservableObjectを実装 |
| **Model** | データモデルの定義（Entity） |
| **Router** | 画面遷移の制御。モジュールの組み立て |

## プロジェクト構造

```
EmptyProject/
├── App/
│   ├── AppDelegate.swift      # アプリケーションデリゲート
│   └── SceneDelegate.swift    # シーンデリゲート
├── Core/
│   └── MVVM/                  # MVVMベースプロトコル
│       ├── ViewModelProtocol.swift
│       ├── RouterProtocol.swift
│       └── ModuleProtocol.swift
├── Modules/
│   ├── Home/                  # Homeモジュール
│   │   ├── HomeEntity.swift
│   │   ├── HomeViewModel.swift
│   │   ├── HomeView.swift
│   │   └── HomeRouter.swift
│   └── Detail/                # Detailモジュール
│       ├── DetailEntity.swift
│       ├── DetailViewModel.swift
│       ├── DetailView.swift
│       └── DetailRouter.swift
└── Info.plist
Scripts/
└── generate_module_mvvm.sh   # モジュール生成スクリプト
```

## モジュール生成

新しいMVVMモジュールを作成するには、以下のコマンドを実行します：

```bash
./Scripts/generate_module_mvvm.sh <ModuleName>
```

### 使用例

```bash
# Settingsモジュールを作成
./Scripts/generate_module_mvvm.sh Settings

# UserProfileモジュールを作成
./Scripts/generate_module_mvvm.sh UserProfile
```

### 生成されるファイル

コマンドを実行すると、以下のファイルが自動生成されます：

- `<ModuleName>Entity.swift` - エンティティ定義（Model）
- `<ModuleName>ViewModel.swift` - ビューモデル
- `<ModuleName>View.swift` - SwiftUI View + UIHostingController
- `<ModuleName>Router.swift` - ルーター

## 画面遷移

このテンプレートでは、`.navigationSheet`などのSwiftUIネイティブの画面遷移ではなく、UIHostingControllerとUINavigationControllerを使用したモジュールベースの画面遷移を採用しています。

### 画面遷移の例

```swift
// Router内での画面遷移
func navigateToDetail(with item: HomeEntity) {
    let detailViewController = DetailRouter.createModule(with: item)
    viewController?.navigationController?.pushViewController(detailViewController, animated: true)
}
```

### 遷移パターン

| パターン | メソッド |
|---------|---------|
| Push | `navigationController?.pushViewController(_:animated:)` |
| Pop | `navigationController?.popViewController(animated:)` |
| Modal表示 | `present(_:animated:completion:)` |
| Modal閉じる | `dismiss(animated:completion:)` |
| ルートに戻る | `navigationController?.popToRootViewController(animated:)` |

## MVVMアーキテクチャの特徴

### ViewModel

- `ObservableObject`プロトコルを実装
- `@Published`プロパティでViewに変更を通知
- ビジネスロジックを処理
- Modelからデータを取得・加工

### View

- SwiftUI Viewを使用
- ViewModelを`@ObservedObject`で監視
- UI表示のみを担当

### Model

- データ構造を定義
- ビジネスロジックは含まない

## 使い方

1. このリポジトリをクローン
2. Xcodeでプロジェクトを開く
3. 必要に応じて新しいモジュールを生成
4. ビジネスロジックとUIを実装

## 要件

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## ライセンス

MIT License
