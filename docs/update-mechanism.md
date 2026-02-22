# OTA 更新機構

[English](./en/update-mechanism.md)

Nezu App は GitHub Releases を利用した OTA (Over-The-Air) 更新システムを備えています。

## 📡 VersionManager

`VersionManager` クラス (`test-app/nezu-app/VersionManager.swift`) が更新チェックの中核です。

### 動作フロー

```
1. GitHub API からリリース一覧を取得
   GET https://api.github.com/repos/nezumi0627/nezu-app/releases

2. Draft リリースを除外し、公開済みリリースのみをフィルタ

3. 最新リリースのタグ名からバージョンを解析
   - v{MAJOR}.{MINOR}.{PATCH} 形式 → バージョン文字列を抽出
   - build-{BUILD_NUMBER}-{HASH} 形式 → ビルド番号を抽出

4. ローカルの CFBundleShortVersionString / CFBundleVersion と比較

5. 最新版が新しい場合 → 更新通知を表示
```

### バージョン比較ロジック

`AppVersion` 構造体が `major.minor.patch.build` の4段階で比較します:

```swift
// 比較順序: major → minor → patch → build
func compare(to other: AppVersion) -> ComparisonResult
```

## 📥 インストール連携

更新が見つかった場合、ブラウザを介さず直接インストーラーを起動することができます。

### SideStore / AltStore 連携

`VersionManager` は端末に **SideStore** または **AltStore** がインストールされているか確認し、URL Scheme を通じて直接 IPA を引き渡します。

1. 最新リリースの `.ipa` アセットを特定
2. `browser_download_url` をパーセントエンコード
3. インストーラーが存在する場合、以下の URL Scheme を開く:
   - `sidestore://install?url={ENCODED_URL}`
   - `altstore://install?url={ENCODED_URL}`
4. インストーラーが見つからない場合のみ、システムブラウザで IPA を直接ダウンロードします。

## 🌐 Web ダウンロードページ

`docs/download.html` では、ブラウザから直接 IPA をダウンロードすることもできます。

- GitHub API をリアルタイムで取得
- 全リリースの一覧・バージョン・公開日時・ファイルサイズを表示
- SHA256 ハッシュによるファイル検証
- 詳細情報（ビルド環境・コミット履歴）を折りたたみで表示

## 🔄 CI/CD との連携

ビルドは `Info.plist` のバージョンが変更された場合のみ実行されます（[ビルドプロセス](./build-process.md)を参照）。

新しいバージョンをリリースするには:

1. `Info.plist` の `CFBundleShortVersionString` / `CFBundleVersion` を更新
2. `main` ブランチにプッシュ
3. → バージョン変更を検知 → ビルド実行 → Draft Release 作成
4. GitHub で Draft Release を公開
5. → アプリ / Web ページで最新版が表示される
