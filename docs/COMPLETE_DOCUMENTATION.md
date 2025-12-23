# Nezu App - 完全技術ドキュメント

[English Version](./en/COMPLETE_DOCUMENTATION.md)

## 📑 目次

- [プロジェクト概要](#プロジェクト概要)
- [アーキテクチャ概要](#アーキテクチャ概要)
- [技術スタック](#技術スタック)
- [ビルドシステム詳細](#ビルドシステム詳細)
- [更新メカニズム](#更新メカニズム)
- [UI/UXデザインシステム](#uiuxデザインシステム)
- [開発環境セットアップ](#開発環境セットアップ)
- [デバッグとテスト](#デバッグとテスト)
- [配布とインストール](#配布とインストール)
- [トラブルシューティング](#トラブルシューティング)

---

## プロジェクト概要

### 🎯 プロジェクトの目的

Nezu Appは、GitHub Actionsを活用した自動ビルドシステムを持つ、モダンなiOSアプリケーションです。主な特徴：

- **自動IPA生成**: コミット毎に署名なしIPAを自動生成
- **OTA更新システム**: アプリ内から最新バージョンを確認・ダウンロード
- **クロスプラットフォーム開発**: Windows 11でSwiftロジックをデバッグ可能
- **プレミアムデザイン**: iOS 26 Liquid Glassデザインシステムを採用

### 📁 プロジェクト構造

```
ipa-builder/
├── .github/
│   └── workflows/
│       └── build-unsigned-ipa.yml    # CI/CDワークフロー定義
├── docs/                              # ドキュメント
│   ├── README.md                      # ドキュメント目次
│   ├── build-process.md               # ビルドプロセス詳細
│   ├── update-mechanism.md            # 更新システム詳細
│   ├── design-guide.md                # デザインガイド
│   └── COMPLETE_DOCUMENTATION.md      # 本ドキュメント
├── test-app/
│   └── nezu-app/                      # iOSアプリケーション本体
│       ├── App.swift                  # アプリエントリーポイント
│       ├── ContentView.swift          # メインビュー
│       ├── UpdateCheckView.swift      # 更新確認UI
│       ├── InfoView.swift             # 開発者情報
│       ├── VersionManager.swift       # バージョン管理ロジック
│       ├── DebugMain.swift           # Windows/CLIデバッグ用
│       ├── Info.plist                 # アプリメタデータ
│       └── Assets.xcassets/           # アセット
├── Package.swift                      # Swift Package Manager定義
├── build.ps1                          # Windowsビルドスクリプト
├── debug-release.json                 # ローカルデバッグ用モックデータ
└── README.md                          # プロジェクトREADME
```

---

## アーキテクチャ概要

### システム全体図

```
┌─────────────────────────────────────────────────────────────┐
│                      GitHub Repository                       │
│  ┌────────────────┐         ┌─────────────────────────┐    │
│  │  Source Code   │ ──Push→ │   GitHub Actions        │    │
│  │  (main branch) │         │  (build-unsigned-ipa)   │    │
│  └────────────────┘         └───────────┬─────────────┘    │
│                                          │                   │
│                                          ↓                   │
│                              ┌───────────────────────┐      │
│                              │  Build Process        │      │
│                              │  1. Xcode Build       │      │
│                              │  2. IPA Packaging     │      │
│                              │  3. Draft Release     │      │
│                              └───────────┬───────────┘      │
│                                          │                   │
│                                          ↓                   │
│                              ┌───────────────────────┐      │
│                              │   GitHub Releases     │      │
│                              │   (Draft)             │      │
│                              └───────────┬───────────┘      │
└──────────────────────────────────────────┼──────────────────┘
                                           │
                                           │ Download IPA
                                           ↓
                              ┌────────────────────────┐
                              │    iOS Device          │
                              │  1. SideStore Install  │
                              │  2. OTA Update Check   │
                              │  3. Auto Download      │
                              └────────────────────────┘
```

### コンポーネント構成

#### 1. ビルドシステム (GitHub Actions)
- **トリガー**: main/masterブランチへのプッシュ、PRの作成
- **実行環境**: macOS最新版 + Xcode
- **出力**: 署名なしIPA + Draft Release

#### 2. アプリケーション本体 (SwiftUI)
- **フレームワーク**: SwiftUI + Combine
- **対応OS**: iOS 15.0以降
- **主要機能**:
  - OTA更新確認
  - バージョン管理
  - プレミアムUI表示

#### 3. バージョン管理システム
- **VersionManager**: GitHub APIと連携してバージョン確認
- **更新ロジック**: ビルド番号ベースの比較
- **ダウンロード**: システムブラウザ経由でIPAダウンロード

---

## 技術スタック

### 使用技術一覧

| カテゴリ | 技術/ツール | バージョン | 用途 |
|---------|------------|-----------|------|
| **言語** | Swift | 5.9+ | アプリ開発 |
| **フレームワーク** | SwiftUI | iOS 15.0+ | UI構築 |
| **CI/CD** | GitHub Actions | latest | 自動ビルド |
| **ビルドツール** | Xcode | 15.0+ | iOS/macOSビルド |
| **パッケージ管理** | SPM | 5.9+ | 依存関係管理 |
| **API** | GitHub REST API | v3 | リリース情報取得 |
| **デザイン** | SF Symbols | 4.0+ | アイコン |

### Swift Package Manager 設定

```swift
// Package.swift
let package = Package(
    name: "NezuAppDebug",
    platforms: [
        .macOS(.v12)  // Windows/macOSでのデバッグ用
    ],
    products: [
        .executable(name: "nezu-debug", targets: ["NezuAppDebug"])
    ],
    targets: [
        .executableTarget(
            name: "NezuAppDebug",
            path: "test-app/nezu-app",
            exclude: [
                "App.swift",           // iOS専用
                "ContentView.swift",    // SwiftUI View
                "Info.plist",
                "UpdateCheckView.swift",
                "InfoView.swift",
                "Assets.xcassets",
                "Preview Content"
            ],
            sources: [
                "VersionManager.swift",  // クロスプラットフォーム対応ロジック
                "DebugMain.swift"        // CLIエントリーポイント
            ]
        )
    ]
)
```

---

## ビルドシステム詳細

### GitHub Actions ワークフロー

#### ワークフロー全体像

```yaml
name: Build Unsigned IPA

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:  # 手動実行可能

jobs:
  build:
    runs-on: macos-latest
    permissions:
      contents: write  # Release作成権限
```

#### ビルドステップ詳細

##### Step 1: 環境準備
```yaml
- name: Checkout
  uses: actions/checkout@v4

- name: Select Xcode
  run: sudo xcode-select -s /Applications/Xcode.app

- name: Show Xcode version
  run: xcodebuild -version
```

**処理内容**:
- リポジトリのコードをチェックアウト
- Xcode 15.x系を選択
- ビルド環境のバージョン確認

##### Step 2: プロジェクト検出
```yaml
- name: List available schemes
  run: |
    cd test-app || exit 1
    if [ -f "*.xcworkspace" ]; then
      xcodebuild -list -workspace *.xcworkspace || true
    elif [ -d "nezu-app.xcodeproj" ]; then
      xcodebuild -list -project nezu-app.xcodeproj || true
    fi
```

**処理内容**:
- `.xcworkspace`または`.xcodeproj`を検出
- 利用可能なスキーム一覧を取得

##### Step 3: 署名なしビルド実行
```yaml
- name: Build (unsigned)
  run: |
    cd test-app || exit 1
    PROJECT="nezu-app.xcodeproj"
    SCHEME=$(xcodebuild -list -project "$PROJECT" | grep -A 1 "Schemes:" | tail -n 1 | xargs)
    xcodebuild \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -configuration Release \
      -sdk iphoneos \
      -derivedDataPath ../DerivedData \
      CODE_SIGNING_ALLOWED=NO \
      CODE_SIGN_IDENTITY="" \
      CODE_SIGNING_REQUIRED=NO \
      CODE_SIGNING_ENTITLEMENTS="" \
      build
```

**重要パラメータ**:
- `CODE_SIGNING_ALLOWED=NO`: 署名を無効化
- `CODE_SIGN_IDENTITY=""`: 署名IDを空に設定
- `CODE_SIGNING_REQUIRED=NO`: 署名要求を無効化
- `-configuration Release`: リリースビルド

##### Step 4: .appファイル検出
```yaml
- name: Find built app
  id: find_app
  run: |
    APP_PATH=$(find ./DerivedData -name "*.app" -type d | grep -i "Release-iphoneos" | head -n 1)
    if [ -z "$APP_PATH" ]; then
      APP_PATH=$(find ./DerivedData -name "*.app" -type d | head -n 1)
    fi
    APP_PATH=$(cd "$(dirname "$APP_PATH")" && pwd)/$(basename "$APP_PATH")
    echo "APP_PATH=$APP_PATH" >> $GITHUB_OUTPUT
```

**処理内容**:
- `DerivedData`から`.app`ファイルを検索
- `Release-iphoneos`ビルドを優先
- 絶対パスに変換してGitHub Outputsに保存

##### Step 5: IPAパッケージング
```yaml
- name: Create IPA
  run: |
    TEMP_DIR=$(mktemp -d)
    mkdir -p "$TEMP_DIR/Payload"
    cp -R "${{ steps.find_app.outputs.APP_PATH }}" "$TEMP_DIR/Payload/"
    
    SHORT_SHA=$(echo "${{ github.sha }}" | cut -c1-7)
    IPA_NAME="${{ steps.app_name.outputs.APP_NAME }}-unsigned-build${{ github.run_number }}-${SHORT_SHA}.ipa"
    IPA_PATH="${{ github.workspace }}/$IPA_NAME"
    
    cd "$TEMP_DIR"
    zip -r "$IPA_PATH" Payload -x "*.DS_Store" "*.git*" "*.swp" "*.swo"
```

**IPA構造**:
```
nezu-app-unsigned-build123-abc1234.ipa
└── Payload/
    └── nezu-app.app/
        ├── Info.plist
        ├── nezu-app (実行バイナリ)
        ├── PkgInfo
        ├── Assets.car
        └── ... (その他リソース)
```

**ファイル命名規則**:
- フォーマット: `{APP_NAME}-unsigned-build{BUILD_NUMBER}-{SHORT_SHA}.ipa`
- 例: `nezu-app-unsigned-build5-abc1234.ipa`
- `BUILD_NUMBER`: GitHub Actionsの実行番号（自動インクリメント）
- `SHORT_SHA`: コミットハッシュの最初の7文字

##### Step 6: 検証とリリース作成
```yaml
- name: Upload IPA to Release
  uses: softprops/action-gh-release@v1
  with:
    tag_name: "build-${{ github.run_number }}-${{ github.sha }}"
    name: "Build #${{ github.run_number }} - ${{ github.sha }}"
    body: |
      ## Unsigned IPA Build
      
      - **Commit**: ${{ github.sha }}
      - **Branch**: ${{ github.ref_name }}
      - **Workflow**: ${{ github.workflow }}
      - **Run**: #${{ github.run_number }}
      - **IPA File**: ${{ env.IPA_NAME }}
    draft: true
    prerelease: false
    files: |
      ${{ env.IPA_NAME }}
```

**リリース情報**:
- **Draft**: 公開前にメンテナーが確認可能
- **Tag**: `build-{RUN_NUMBER}-{FULL_SHA}`
- **アセット**: IPAファイル

---

## 更新メカニズム

### VersionManager クラス詳細

#### クラス定義

```swift
@MainActor
class VersionManager: ObservableObject {
    @Published var currentVersion: String
    @Published var latestVersion: String?
    @Published var updateAvailable: Bool = false
    @Published var downloadUrl: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let githubRepo = "nezumi0627/nezu-app"
    private let apiBaseUrl = "https://api.github.com/repos"
}
```

#### バージョン取得ロジック

##### 1. 現在のバージョン検出

```swift
init() {
    #if os(iOS)
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
       let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        self.currentVersion = "\(version).\(build)"
    } else {
        self.currentVersion = "1.0.1"
    }
    #else
    self.currentVersion = "1.0.1"
    #endif
}
```

**取得元**:
- iOS: `Info.plist`の`CFBundleShortVersionString` + `CFBundleVersion`
- 非iOS: デフォルト値 `1.0.1`

**バージョン形式**:
- `{MAJOR}.{MINOR}.{BUILD}`
- 例: `1.0.5` → メジャー1, マイナー0, ビルド5

##### 2. 最新バージョン確認

```swift
func checkForUpdates() {
    isLoading = true
    errorMessage = nil
    
    #if !os(iOS)
    // ローカルモックを優先使用
    let localPath = "debug-release.json"
    if FileManager.default.fileExists(atPath: localPath) {
        let data = try Data(contentsOf: URL(fileURLWithPath: localPath))
        processReleaseData(data)
        return
    }
    #endif
    
    // GitHub API呼び出し
    let urlString = "\(apiBaseUrl)/\(githubRepo)/releases"
    guard let url = URL(string: urlString) else { return }
    
    var request = URLRequest(url: url)
    request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
    
    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
        Task { @MainActor in
            guard let self = self, let data = data else { return }
            self.processReleaseData(data)
            self.isLoading = false
        }
    }.resume()
}
```

**API エンドポイント**:
```
GET https://api.github.com/repos/nezumi0627/nezu-app/releases
```

**レスポンス例**:
```json
[
  {
    "tag_name": "build-5-abc1234567890abcdef1234567890abcdef12",
    "name": "Build #5 - abc1234567890abcdef1234567890abcdef12",
    "draft": true,
    "assets": [
      {
        "name": "nezu-app-unsigned-build5-abc1234.ipa",
        "browser_download_url": "https://github.com/.../nezu-app.ipa"
      }
    ],
    "published_at": "2025-12-24T10:30:00Z"
  }
]
```

##### 3. リリースデータ処理

```swift
private func processReleaseData(_ data: Data) {
    let releases = try JSONDecoder().decode([ReleaseInfo].self, from: data)
    
    // Draft Releaseを優先、なければ通常のRelease
    let draftReleases = releases.filter { $0.draft }
    let availableReleases = draftReleases.isEmpty ? releases : draftReleases
    
    guard let latestRelease = availableReleases.first else { return }
    
    let tagVersion = extractVersionFromTag(latestRelease.tagName)
    
    // IPAまたはSwiftファイルを検索
    if let ipaAsset = latestRelease.assets.first(where: { $0.name.hasSuffix(".ipa") }) {
        self.latestVersion = tagVersion
        self.downloadUrl = ipaAsset.browserDownloadUrl
        updateCompareLogic(tagVersion: tagVersion)
    }
}
```

**検索優先度**:
1. Draft Release内の`.ipa`ファイル
2. Draft Releaseがない場合、通常Releaseの`.ipa`
3. `.ipa`がない場合、`.swift`ファイル（Windowsビルド用）

##### 4. バージョン比較ロジック

```swift
private func updateCompareLogic(tagVersion: String) {
    let currentBuildStr = self.currentVersion.components(separatedBy: ".").last ?? "1"
    if let currentBuild = Int(currentBuildStr),
       let latestBuild = Int(tagVersion) {
        self.updateAvailable = latestBuild > currentBuild
    } else {
        self.updateAvailable = tagVersion != self.currentVersion
    }
}

private func extractVersionFromTag(_ tag: String) -> String {
    // "build-5-abc1234" から "5" を抽出
    let components = tag.components(separatedBy: "-")
    if components.count >= 2 {
        return components[1]
    }
    return tag
}
```

**比較アルゴリズム**:
1. タグから`build-{N}-{SHA}`の`N`を抽出
2. 現在のビルド番号と比較
3. `latestBuild > currentBuild`なら更新あり

**例**:
- 現在: `1.0.3` → ビルド番号 `3`
- 最新タグ: `build-5-abc1234` → ビルド番号 `5`
- 結果: `5 > 3` → `updateAvailable = true`

##### 5. ダウンロード処理

```swift
func downloadIPA() {
    guard let downloadUrl = downloadUrl,
          let url = URL(string: downloadUrl) else { return }
    
    #if os(iOS)
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)  // Safariでダウンロードページを開く
    }
    #else
    print("Download URL: \(downloadUrl)")  // デバッグ出力
    #endif
}
```

**動作**:
- iOS: `UIApplication.shared.open()` → Safariで開く → ブラウザダウンロード
- 非iOS: URLをコンソールに出力

---

## UI/UXデザインシステム

### iOS 26 Liquid Glass デザイン哲学

#### デザイン原則

1. **奥行きとレイヤリング**
   - ガラスモーフィズムによる透明感
   - 複数レイヤーによる空間的奥行き
   - 微細な影による浮遊感

2. **流動的なアニメーション**
   - イージング関数による自然な動き
   - スプリングアニメーションの活用
   - 継続的な背景アニメーション

3. **プレミアムな配色**
   - 深海ブルー基調 (`#020617`)
   - シアン・パープルのアクセント
   - グラデーション多用

#### コンポーネント詳細

##### 1. LiquidBackground (動的背景)

```swift
struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            BlobView(color: .blue.opacity(0.4), size: 400, 
                    offset: animate ? CGPoint(x: 100, y: -200) : CGPoint(x: -100, y: -300))
            BlobView(color: .purple.opacity(0.3), size: 500,
                    offset: animate ? CGPoint(x: -150, y: 200) : CGPoint(x: 180, y: 300))
            BlobView(color: .cyan.opacity(0.2), size: 350,
                    offset: animate ? CGPoint(x: 200, y: 300) : CGPoint(x: -200, y: 100))
        }
        .blur(radius: 80)
        .onAppear {
            withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

struct BlobView: View {
    let color: Color
    let size: CGFloat
    let offset: CGPoint
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .offset(x: offset.x, y: offset.y)
    }
}
```

**特徴**:
- 3つの半透明円が15秒周期で移動
- 80ptのガウシアンブラーで融合
- 無限ループアニメーション

##### 2. LiquidGlassButton

```swift
struct LiquidGlassButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let colors: [Color]
    let action: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: colors, 
                              startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 50, height: 50)
                        .shadow(color: colors[0].opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .clear, .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .scaleEffect(isHovering ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
```

**視覚要素**:
- アイコン円: グラデーション + ドロップシャドウ
- テキスト: タイトル（太字） + サブタイトル（半透明）
- 背景: `.ultraThinMaterial` + 縁取りグラデーション
- インタラクション: ホバー時0.98倍にスケール

##### 3. UpdateCheckView (更新確認画面)

```swift
struct UpdateCheckView: View {
    @StateObject private var versionManager = VersionManager()
    @Environment(\.dismiss) var dismiss
    @State private var startAnimation = false
    
    var body: some View {
        ZStack {
            Color(hex: "020617").ignoresSafeArea()
            LiquidBackground()
            
            VStack(spacing: 32) {
                // ヘッダー
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.blue.opacity(0.4), .clear], 
                                  startPoint: .top, endPoint: .bottom))
                            .frame(width: 120, height: 120)
                            .blur(radius: 20)
                        
                        Image(systemName: "arrow.up.square.fill")
                            .font(.system(size: 70, weight: .thin))
                            .foregroundStyle(
                                LinearGradient(colors: [.white, .blue.opacity(0.6)], 
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .shadow(color: .blue.opacity(0.5), radius: 15, x: 0, y: 10)
                    }
                    .scaleEffect(startAnimation ? 1.0 : 0.8)
                    .rotationEffect(.degrees(startAnimation ? 0 : -10))
                    
                    VStack(spacing: 4) {
                        Text("Software Update")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                        Text("Checking for latest build...")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
                
                // ステータス表示（条件分岐）
                VStack {
                    if versionManager.isLoading {
                        PremiumLoadingView()
                    } else if let error = versionManager.errorMessage {
                        PremiumErrorView(message: error)
                    } else if versionManager.updateAvailable {
                        PremiumUpdateCard(versionManager: versionManager)
                    } else {
                        PremiumUpToDateView(version: versionManager.currentVersion)
                    }
                }
                
                // 更新ボタン
                Button(action: { versionManager.checkForUpdates() }) {
                    HStack {
                        if versionManager.isLoading {
                            ProgressView().tint(.white)
                        }
                        Text(versionManager.isLoading ? "SECURE CHECK..." : "FORCE REFRESH")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        versionManager.isLoading ? 
                        Color.white.opacity(0.1) :
                        LinearGradient(colors: [.blue, .blue.opacity(0.6)], 
                                     startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .disabled(versionManager.isLoading)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                startAnimation = true
            }
            versionManager.checkForUpdates()
        }
    }
}
```

**UI状態管理**:

| 状態 | 表示コンポーネント | 説明 |
|-----|------------------|------|
| `isLoading` | `PremiumLoadingView` | ローディングアニメーション |
| `errorMessage != nil` | `PremiumErrorView` | エラーメッセージ |
| `updateAvailable` | `PremiumUpdateCard` | 更新可能表示 + ダウン