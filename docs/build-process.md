# ビルドと配布プロセス

[English](./en/build-process.md)

Nezu App は、完全に自動化された CI/CD パイプラインを使用して、すべてのコード変更を検証し、配布用にパッケージ化します。

## 🚀 GitHub Actions ワークフロー
ビルドは `.github/workflows/build-unsigned-ipa.yml` で定義されています。

### 1. ビルド環境
- **プラットフォーム**: `macos-latest` (Apple の最新 Xcode 環境)
- **ツール**: `xcodebuild`, `zip`, `git`

### 2. 署名なし IPA の作成
このプロジェクトはサイドロードを目的としているため、**署名なし** IPA を生成します。
- `CODE_SIGNING_ALLOWED=NO`
- `CODE_SIGNING_REQUIRED=NO`

### 3. パッケージ構造
IPA は `.app` バンドルを `Payload` ディレクトリにパッケージ化することで作成されます：
```text
nezu-app.ipa
└── Payload/
    └── nezu-app.app/
        ├── Info.plist
        ├── PkgInfo
        └── ... (コンパイル済みバイナリとアセット)
```

## 📦 配布
ビルドが完了すると、IPA は GitHub 上の **下書きリリース (Draft Release)** としてアップロードされます。
- **タグ名の命名規則**: `build-{RUN_NUMBER}-{SHA}`
- **セキュリティ**: 下書きリリースにより、メンテナーは公開前にビルドを確認できます。
