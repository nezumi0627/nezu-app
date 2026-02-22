# デザイン哲学: iOS 26 Liquid Glass

[English](./en/design-guide.md)

Nezu App は iOS 26 で導入された **Liquid Glass** デザインシステムを公式 API で実装しています。

## 🔧 使用している API

### `glassEffect()` モディファイア

ビューにガラス効果を適用する SwiftUI モディファイア。背景をぼかし、光と色を反射する半透明な外観を作成します。

```swift
// 基本形 — 角丸のガラス効果
VStack { ... }
    .glassEffect(in: .rect(cornerRadius: 16))

// カプセル形状
Text("タグ")
    .padding(.horizontal, 12)
    .padding(.vertical, 6)
    .glassEffect(in: .capsule)

// 円形
Image(systemName: "app.fill")
    .frame(width: 80, height: 80)
    .glassEffect(in: .circle)

// インタラクティブ — タッチに反応
Link("リンク") { }
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))
```

### バリエーション

| バリアント     | 用途                    |
| -------------- | ----------------------- |
| `.regular`     | 通常の UI（デフォルト） |
| `.clear`       | メディアが多い背景      |
| `.interactive` | タッチ操作に反応        |

### `GlassEffectContainer`

複数のガラス要素をグループ化し、モーフィングトランジションを可能にするコンテナ。

```swift
GlassEffectContainer {
    VStack(spacing: 16) {
        Text("Item 1").glassEffect(in: .capsule)
        Text("Item 2").glassEffect(in: .capsule)
    }
}
```

### ボタンスタイル

```swift
Button("アクション") { }
    .buttonStyle(.glass)            // ガラスボタン

Button("重要") { }
    .buttonStyle(.glassProminent)   // 強調ガラスボタン
```

## 📐 デザイン原則

### 1. ナビゲーションレイヤー

Liquid Glass は**ナビゲーション層**（ツールバー、タブバー、コントロール）に使用します。コンテンツの上にガラスが浮かぶ視覚階層を作ります。

### 2. 自動適用

iOS 26 でコンパイルすると、以下の要素は自動的に Liquid Glass スタイルになります:

- `TabView` のタブバー
- `NavigationStack` のツールバー
- `.borderedProminent` ボタン

### 3. シンプルに保つ

- ガラス効果の過度な入れ子を避ける
- コンテンツの視認性を最優先にする
- 背景のアニメーションは不要 — OS が自動で光を処理する

## 📁 Nezu App での使用箇所

| ファイル                | 使用方法                                                                    |
| ----------------------- | --------------------------------------------------------------------------- |
| `ContentView.swift`     | アプリアイコン (`.circle`)、機能リスト・デバイス情報 (`.rect`)              |
| `InfoView.swift`        | プロフィール画像 (`.circle`)、詳細カード (`.rect`)、リンク (`.interactive`) |
| `UpdateCheckView.swift` | バージョン表示・ステータスカード (`.rect`)、DL ボタン (`.glass`)            |
