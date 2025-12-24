import SwiftUI

// iOS 26未満のフォールバック実装
// iOS 26以降では、ネイティブAPIが優先されます
struct GlassEffectContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
    }
}

enum GlassEffectStyle {
    case interactive
    case regular
}

extension View {
    @ViewBuilder
    func glassEffect(_ style: GlassEffectStyle = .interactive, in shape: some Shape) -> some View {
        self.background(.ultraThinMaterial, in: shape)
            .overlay(
                shape
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.25),
                                .white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
                    .blendMode(.overlay)
            )
            .overlay(
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.15),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.overlay)
            )
            .shadow(
                color: .black.opacity(0.1),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

