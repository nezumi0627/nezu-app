import SwiftUI

// MARK: - Shared Components

struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Main Glowing Blobs
            BlobView(color: .blue.opacity(0.4), size: 400, offset: animate ? CGPoint(x: 100, y: -200) : CGPoint(x: -100, y: -300))
            BlobView(color: .purple.opacity(0.3), size: 500, offset: animate ? CGPoint(x: -150, y: 200) : CGPoint(x: 180, y: 300))
            BlobView(color: .cyan.opacity(0.2), size: 350, offset: animate ? CGPoint(x: 200, y: 300) : CGPoint(x: -200, y: 100))
        }
        .blur(radius: 80)
        .onAppear {
            withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

struct BlobView: View {
    let color: Color
    let size: CGFloat
    let offset: CGPoint
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .offset(x: offset.x, y: offset.y)
    }
}

// MARK: - Extensions

extension View {
    @ViewBuilder
    func glassEffect(in shape: some Shape = .capsule) -> some View {
        if #available(iOS 18.0, visionOS 2.0, *) {
            self.background(.glass, in: shape)
                .glassEffect(in: shape)
        } else {
            self.background(.ultraThinMaterial, in: shape)
                .overlay(shape.stroke(Color.white.opacity(0.2), lineWidth: 0.5))
        }
    }
    
    func glassShimmer(animate: Bool) -> some View {
        self.modifier(ShimmerEffect(animate: animate))
    }
}

struct ShimmerEffect: ViewModifier {
    let animate: Bool
    @State private var phase: CGFloat = -1.0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.15), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geo.size.width * 0.5)
                    .offset(x: phase * geo.size.width * 1.5)
                    .rotationEffect(.degrees(30))
                }
            )
            .onAppear {
                if animate {
                    withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                        phase = 1.0
                    }
                }
            }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static let emerald = Color(hex: "10b981")
}
