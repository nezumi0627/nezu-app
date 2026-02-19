# ビルドと配布プロセス

[English](./en/build-process.md)

Nezu App は GitHub Actions を使用して署名無し IPA を自動ビルドし、GitHub Releases で配布します。

## 🔄 ビルドトリガー

ビルドは **バージョン変更時のみ** 実行されます。

| トリガー             | 条件                                                                                       |
| -------------------- | ------------------------------------------------------------------------------------------ |
| `push` (main/master) | `Info.plist` の `CFBundleShortVersionString` または `CFBundleVersion` が変更された場合のみ |
| `workflow_dispatch`  | 手動実行 — 常にビルド                                                                      |

### バージョン変更検知の仕組み

1. `check-version` ジョブが `ubuntu-latest` で先に実行される（軽量・高速）
2. `Info.plist` の現在のバージョンと前コミットのバージョンを `git show HEAD~1` で比較
3. 変更がない場合 → ビルドをスキップし、Summary に通知
4. 変更がある場合 → `build` ジョブが `macos-latest` で実行される

### バージョンの更新方法

`test-app/nezu-app/Info.plist` の以下のフィールドを変更してください:

```xml
<key>CFBundleShortVersionString</key>
<string>1.1.0</string>      <!-- バージョン番号 (例: 1.0 → 1.1.0) -->
<key>CFBundleVersion</key>
<string>2</string>           <!-- ビルド番号 (例: 1 → 2) -->
```

## 🚀 ワークフロー構成

ワークフローは `.github/workflows/build-unsigned-ipa.yml` で定義されています。

### ジョブ構成

```
check-version (ubuntu-latest)  ← 高速・無料 tier
    ↓ should_build=true?
build (macos-latest)           ← バージョン変更時のみ実行
    ↓ should_build=false?
skip-notice (ubuntu-latest)    ← スキップ通知
```

### ビルド環境

| 項目       | 値                                 |
| ---------- | ---------------------------------- |
| Runner     | `macos-latest`                     |
| Xcode      | 26.1                               |
| 署名       | `CODE_SIGNING_ALLOWED=NO`          |
| キャッシュ | DerivedData (Swift ソースハッシュ) |

## 📦 IPA の作成

### 署名なしビルド

サイドロードを目的としているため、署名なし IPA を生成します:

- `CODE_SIGNING_ALLOWED=NO`
- `CODE_SIGNING_REQUIRED=NO`
- `CODE_SIGN_IDENTITY=""`

### IPA ファイル命名規則

```
{AppName}-v{VERSION}-build{BUILD_NUM}-{SHORT_SHA}.ipa
```

例: `nezu-app-v1.1.0-build2-831eddd.ipa`

### パッケージ構造

```
nezu-app.ipa
└── Payload/
    └── nezu-app.app/
        ├── Info.plist
        ├── PkgInfo
        └── ... (コンパイル済みバイナリとアセット)
```

## 📤 配布

ビルド完了後、IPA は GitHub の **下書きリリース (Draft Release)** としてアップロードされます。

| 項目       | 値                                                  |
| ---------- | --------------------------------------------------- |
| タグ名     | `v{VERSION}-build{BUILD_NUM}` (例: `v1.1.0-build2`) |
| リリース名 | `Nezu App v{VERSION} (Build {BUILD_NUM})`           |
| 状態       | Draft (メンテナーが確認後に公開)                    |

### リリースに含まれる情報

- バージョン / ビルド番号
- コミットハッシュ / ブランチ
- IPA ファイルサイズ / SHA256 ハッシュ
- ビルド環境 (Xcode / Swift / iOS SDK)
- 直近 10 件のコミット一覧

## 🌐 ダウンロードページ

`docs/download.html` にて、GitHub API からリリース情報を取得し IPA をダウンロードできる Web ページを提供しています。

- 全リリースの一覧表示
- バージョン・公開日時・ファイルサイズ・ダウンロード数
- SHA256 ハッシュ・ビルド環境・コミット履歴（折りたたみ）
