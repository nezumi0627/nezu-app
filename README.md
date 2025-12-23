# IPA Builder

GitHub Actions を使用して署名無し IPA をビルドするプロジェクトです。

## 概要

このプロジェクトは、Apple Developer Program（有料）に登録せずに、GitHub Actions 上で署名無し IPA を生成します。生成した IPA は SideStore を使用して iOS 実機にインストールできます。

## プロジェクト構成

このリポジトリには、iOS アプリ（`nezu-app`）が含まれています。

- **nezu-app**: SwiftUI で作成されたカウンターアプリ
  - プロジェクトパス: `nezu-app/nezu-app.xcodeproj`
  - Scheme: `nezu-app`
  - アプリ名: Nezu App

このテストアプリは、GitHub Actions でのビルドプロセスを検証するために使用できます。

## 前提条件

### ローカル Xcode での設定（必須）

**重要**: 以下の設定をローカルの Xcode で事前に行ってください。

1. Xcode で `nezu-app/nezu-app.xcodeproj` を開く
2. プロジェクトを選択 → **Signing & Capabilities** タブ
3. 以下の設定を行う：
   - **Automatically manage signing**: **OFF**
   - **Team**: **None**

この設定を行わないと、GitHub Actions でのビルドが失敗します。

**注意**: プロジェクトファイルは既に `CODE_SIGN_STYLE = Manual` に設定されていますが、Xcode で開いて確認することをお勧めします。

## 使用方法

### 1. プロジェクトを GitHub にプッシュ

```bash
git add .
git commit -m "Add iOS project"
git push origin main
```

### 2. GitHub Actions でビルド

- `main` ブランチにプッシュすると自動的にビルドが開始されます
- または、GitHub リポジトリの **Actions** タブから手動で実行できます（`workflow_dispatch`）

### 3. IPA のダウンロード

**推奨方法（.ipaファイルとして直接ダウンロード）:**

1. GitHub リポジトリ → **Releases** タブ
2. 最新の **Draft** リリースを選択（`Build #XX` という名前）
3. **Assets** セクションから `.ipa` ファイルを直接ダウンロード

**代替方法（Artifactからダウンロード）:**

1. GitHub リポジトリ → **Actions** タブ
2. 実行されたワークフローを選択
3. **Artifacts** セクションから `unsigned-ipa-backup` をダウンロード
4. ダウンロードしたzipファイルを展開して `.ipa` ファイルを取得

**注意**: Artifactからダウンロードした場合は、zipファイルを展開する必要があります。Releaseからダウンロードした場合は、直接 `.ipa` ファイルとしてダウンロードできます。

## SideStore でのインストール

1. iPhone に SideStore をインストール
2. SideStore を起動
3. 「＋」ボタンを押す
4. 生成した `.ipa` ファイルを選択
5. Apple ID（無料）で署名
6. インストール完了

**注意**: SideStore で署名されたアプリは 7 日間有効です。期限が切れたら再インストールが必要です。

## ワークフローのカスタマイズ

`.github/workflows/build-unsigned-ipa.yml` ファイルを編集することで、ビルド設定をカスタマイズできます。

### 主な設定項目

- **ブランチ**: `on.push.branches` でビルドをトリガーするブランチを指定
- **Scheme**: ワークフローが自動的に検出しますが、明示的に指定することも可能
- **Configuration**: デフォルトは `Release`、`Debug` に変更可能

## トラブルシューティング

### Provisioning Profile エラー

```
requires a provisioning profile
```

**解決方法**:
- Xcode で `CODE_SIGNING_ALLOWED=NO` が設定されているか確認
- Xcode 側で Team が None に設定されているか確認

### .app ファイルが見つからない

ワークフローは自動的に `.app` ファイルを検索しますが、見つからない場合：

1. ビルドログを確認して、実際のビルドパスを確認
2. `.github/workflows/build-unsigned-ipa.yml` の `Find built app` ステップを調整

### Scheme が見つからない

プロジェクトに複数の Scheme がある場合、ワークフローは最初に見つかった Scheme を使用します。特定の Scheme を使用したい場合は、ワークフローファイルを編集して明示的に指定してください。

## 制約事項

- 生成される IPA は **署名無し**
- SideStore により署名されるため有効期限は **7日**
- App Store / TestFlight 配布不可
- 自己責任での運用が必要
- 本手法は Apple の公式配布手段ではない

## セキュリティ・注意事項

- 本手法は Apple の公式配布手段ではありません
- 企業配布・商用配布には使用不可
- Apple ID の利用制限・ポリシー変更により利用不可となる可能性があります
- 開発・検証・個人利用を目的として使用してください

## ライセンス

このプロジェクトは開発・検証・個人利用を目的としています。

