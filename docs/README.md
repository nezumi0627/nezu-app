# Nezu App ドキュメント

[English](./en/README.md)

Nezu App の公式ドキュメントへようこそ。ここでは、ビルドシステム、更新機構、およびプレミアムデザイン基準についての包括的なガイドを提供します。

## 📖 目次

### [ビルドと配布](./build-process.md)

GitHub Actions を使用して IPA を自動ビルドし、GitHub Releases で配布するプロセスの詳細。

- **バージョン変更検知** — `Info.plist` のバージョンが変わった時のみビルド実行
- **署名無し IPA** — SideStore でのサイドロードを前提
- **自動リリース** — Draft Release として IPA をアップロード

### [OTA 更新システム](./update-mechanism.md)

アプリ内からの更新チェックと IPA ダウンロードの仕組み。

- **VersionManager** — GitHub API からバージョンを取得・比較
- **Web ダウンロードページ** — `docs/download.html` でブラウザから直接 DL

### [デザイン哲学](./design-guide.md)

**iOS 26 Liquid Glass** デザインシステム、UI/UX 標準、および美的なコンポーネントについての洞察。

---

## 🚀 クイックスタート

1. `test-app/nezu-app/Info.plist` のバージョンを更新
2. `main` ブランチにプッシュ
3. GitHub Actions がバージョン変更を検知して自動ビルド
4. **Releases** タブから Draft Release を公開
5. SideStore で IPA をインストール

```
*注: 'swift' が認識されない場合は、[swift.org](https://www.swift.org/install/windows/) から Swift ツールチェーンをインストールしてください。*
```
