# Design Philosophy: iOS 26 Liquid Glass

[Japanese](../design-guide.md)

Nezu App implements the **Liquid Glass** design system using the official iOS 26 APIs.

## 🔧 APIs Used

### `glassEffect()` modifier

The primary SwiftUI modifier for applying glass effects. Creates a translucent appearance that blurs background content and reflects light and color.

```swift
// Basic — rounded rectangle glass
VStack { ... }
    .glassEffect(in: .rect(cornerRadius: 16))

// Capsule shape
Text("Tag")
    .padding(.horizontal, 12)
    .padding(.vertical, 6)
    .glassEffect(in: .capsule)

// Circle
Image(systemName: "app.fill")
    .frame(width: 80, height: 80)
    .glassEffect(in: .circle)

// Interactive — responds to touch
Link("Link") { }
    .glassEffect(.interactive, in: .rect(cornerRadius: 14))
```

### Variants

| Variant        | Usage                  |
| -------------- | ---------------------- |
| `.regular`     | Standard UI (default)  |
| `.clear`       | Media-rich backgrounds |
| `.interactive` | Touch-responsive glass |

### `GlassEffectContainer`

Groups multiple glass elements together, enabling morphing transitions and consistent rendering.

```swift
GlassEffectContainer {
    VStack(spacing: 16) {
        Text("Item 1").glassEffect(in: .capsule)
        Text("Item 2").glassEffect(in: .capsule)
    }
}
```

### Button styles

```swift
Button("Action") { }
    .buttonStyle(.glass)            // Glass button

Button("Important") { }
    .buttonStyle(.glassProminent)   // Prominent glass button
```

## 📐 Design Principles

### 1. Navigation layer

Liquid Glass is used for the **navigation layer** (toolbars, tab bars, controls). It creates a visual hierarchy where glass floats above content.

### 2. Automatic adoption

When compiled with iOS 26, these elements automatically adopt Liquid Glass:

- `TabView` tab bars
- `NavigationStack` toolbars
- `.borderedProminent` buttons

### 3. Keep it simple

- Avoid excessive nesting of glass effects
- Prioritize content readability
- No custom background animations needed — the OS handles light reflections automatically

## 📁 Usage in Nezu App

| File                    | Usage                                                                     |
| ----------------------- | ------------------------------------------------------------------------- |
| `ContentView.swift`     | App icon (`.circle`), feature list & device info (`.rect`)                |
| `InfoView.swift`        | Profile image (`.circle`), detail cards (`.rect`), links (`.interactive`) |
| `UpdateCheckView.swift` | Version display & status cards (`.rect`), download button (`.glass`)      |
