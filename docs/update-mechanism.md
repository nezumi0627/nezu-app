# OTA 更新機構

[English](./en/update-mechanism.md)

Nezu App は、手動での確認を不要にするカスタムの Over-The-Air (OTA) 更新システムを備えています。

## 📡 VersionManager のロジック
`VersionManager` クラスは更新システムの核心です。

### 情報の取得
GitHub API からリリースデータを取得します：
`GET https://api.github.com/repos/nezumi0627/nezu-app/releases`

### バージョンの解析
タグベースのバージョニングシステムを使用しています：
- **形式**: `build-{BUILD_NUMBER}-{COMMIT_HASH}`
- **ロジック**: マネージャーは `{BUILD_NUMBER}` を抽出し、ローカルの `CFBundleVersion` と比較します。

### ダウンロード戦略
更新が見つかった場合：
1. アプリは最新リリース内の `.ipa` アセットを特定します。
2. `browser_download_url` を保存します。
3. UI に「IPA をダウンロード」ボタンを表示し、システムブラウザで URL を開きます。

## 💻 クロスプラットフォーム互換性
`VersionManager` は可能な限りプラットフォームに依存しないように書かれています：
- **iOS**: `UIApplication` を使用してダウンロードリンクを開きます。
- **その他 (Windows/CLI)**: デバッグ用に URL を出力します。
