# デザイン哲学: iOS 26 Liquid Glass

[English](./en/design-guide.md)

Nezu App は、**Liquid Glass**（リキッド・グラス）と呼ばれる最高級の美的基準を遵守しています。

## ✨ 視覚的スタンダード

### 1. 奥行きと透明度
- **超薄型マテリアル**: ガラスのような感覚を作り出すために、背景がぼやけたマテリアルを使用しています。
- **レイヤリング**: 各コンポーネントは、奥行きを出すために微細な影とともにレイヤー化されています。

### 2. 彩度と輝き
- **グラデーション**: 深海のようなブルー、スレート、そして鮮やかなシアンやパープルのアクセント。
- **ダイナミックな輝き**: 背景でゆっくりとアニメーションする光の球体が、UI に生命を吹き込みます。

### 3. タイポグラフィと形状
- **角丸**: 親しみやすくモダンな感触を出すために、大きな角丸（20pt以上）を採用しています。
- **SF Symbols**: 一貫したアイコン表示のために、Apple の SF Symbols を意図的に使用しています。

## 🛠️ 実装例
```swift
// ガラス背景の例
RoundedRectangle(cornerRadius: 20)
    .fill(.ultraThinMaterial)
    .overlay(
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
    )
```
