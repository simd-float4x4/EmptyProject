# SwiftUI VIPER Template

SwiftUIとVIPERアーキテクチャを組み合わせたiOSアプリのテンプレートリポジトリです。

## アーキテクチャ概要

このテンプレートは、UIHostingControllerを使用したモジュールベースの画面遷移を採用しています。

```
┌─────────────────────────────────────────────────────────────┐
│                         Module                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────┐    ┌───────────┐    ┌────────────┐            │
│  │  View   │◄──►│ Presenter │◄──►│ Interactor │            │
│  └─────────┘    └───────────┘    └────────────┘            │
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
| **Interactor** | ビジネスロジックの実装。データの取得・加工を担当 |
| **Presenter** | ViewとInteractorの仲介。表示用データの準備 |
| **Entity** | データモデルの定義 |
| **Router** | 画面遷移の制御。モジュールの組み立て |

## プロジェクト構造

```
EmptyProject/
├── App/
│   ├── AppDelegate.swift      # アプリケーションデリゲート
│   └── SceneDelegate.swift    # シーンデリゲート
├── Core/
│   └── VIPER/                 # VIPERベースプロトコル
│       ├── ViewProtocol.swift
│       ├── InteractorProtocol.swift
│       ├── PresenterProtocol.swift
│       ├── RouterProtocol.swift
│       └── ModuleProtocol.swift
├── Modules/
│   ├── Home/                  # Homeモジュール
│   │   ├── HomeProtocols.swift
│   │   ├── HomeEntity.swift
│   │   ├── HomeView.swift
│   │   ├── HomePresenter.swift
│   │   ├── HomeInteractor.swift
│   │   └── HomeRouter.swift
│   └── Detail/                # Detailモジュール
│       ├── DetailProtocols.swift
│       ├── DetailEntity.swift
│       ├── DetailView.swift
│       ├── DetailPresenter.swift
│       ├── DetailInteractor.swift
│       └── DetailRouter.swift
└── Info.plist
Scripts/
└── generate_module.sh         # モジュール生成スクリプト
```

## モジュール生成

新しいVIPERモジュールを作成するには、以下のコマンドを実行します：

```bash
./Scripts/generate_module.sh <ModuleName>
```

### 使用例

```bash
# Settingsモジュールを作成
./Scripts/generate_module.sh Settings

# UserProfileモジュールを作成
./Scripts/generate_module.sh UserProfile
```

### 生成されるファイル

コマンドを実行すると、以下のファイルが自動生成されます：

- `<ModuleName>Protocols.swift` - プロトコル定義
- `<ModuleName>Entity.swift` - エンティティ定義
- `<ModuleName>View.swift` - SwiftUI View + UIHostingController
- `<ModuleName>Presenter.swift` - プレゼンター
- `<ModuleName>Interactor.swift` - インタラクター
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

