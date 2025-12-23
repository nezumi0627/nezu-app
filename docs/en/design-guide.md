# Design Philosophy: iOS 26 Liquid Glass

[Japanese](../design-guide.md)

Nezu App adheres to a high-end, premium aesthetic referred to as **Liquid Glass**.

## ✨ Visual Standards

### 1. Depth & Transparency
- **Ultra-thin Material**: We use blurred background materials to create a sense of glass.
- **Layering**: Components are layered with subtle shadows to provide depth.

### 2. Vibrancy
- **Gradients**: Deep-sea blues, slate, and vibrant cyan/purple accents.
- **Dynamic Glows**: Background glowing orbs that animate slowly to make the UI feel alive.

### 3. Typography & Shapes
- **Rounded Corners**: Generous corner radii (20pt+) for a friendly, modern feel.
- **SF Symbols**: Purposeful use of Apple's SF Symbols for consistent iconography.

## 🛠️ Implementation Example
```swift
// Example of a Glass Background
RoundedRectangle(cornerRadius: 20)
    .fill(.ultraThinMaterial)
    .overlay(
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
    )
```
