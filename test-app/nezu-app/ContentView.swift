import SwiftUI

struct ContentView: View {
    @State private var showUpdateView = false
    @State private var showInfoView = false
    @StateObject private var versionManager = VersionManager()
    @State private var appearAnimation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Depth
                Color(hex: "020617").ignoresSafeArea()
                
                // Dynamic Liquid Blobs for color depth
                LiquidBackground()
                
                // Root Liquid Glass Container
                if #available(iOS 18.0, visionOS 2.0, *) {
                    GlassEffectContainer(spacing: 24) { // 融合しやすさを調整
                        mainContent
                    }
                } else {
                    mainContent
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showInfoView) {
                InfoView()
            }
            .sheet(isPresented: $showUpdateView) {
                UpdateCheckView()
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    appearAnimation = true
                }
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Header Section
                VStack(spacing: 24) {
                    ZStack {
                        // Official Liquid Glass Effect
                        Circle()
                            .frame(width: 140, height: 140)
                            .glassEffect()
                            .glassShimmer(animate: appearAnimation)
                        
                        Image(systemName: "app.dashed")
                            .font(.system(size: 65, weight: .light))
                            .foregroundStyle(
                                LinearGradient(colors: [.white, .blue.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .shadow(color: .blue.opacity(0.5), radius: 15, x: 0, y: 10)
                    }
                    .scaleEffect(appearAnimation ? 1.0 : 0.8)
                    .opacity(appearAnimation ? 1.0 : 0)
                    
                    VStack(spacing: 8) {
                        Text("Nezu App")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.white, .white.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                            )
                        
                        Text("ADVANCED IPA MANAGEMENT")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.cyan.opacity(0.8))
                            .kerning(2)
                    }
                }
                .padding(.top, 60)
                
                // Action Grid
                VStack(spacing: 16) {
                    LiquidGlassButton(
                        title: "Check for Updates",
                        subtitle: "Current version: v\(versionManager.currentVersion)",
                        icon: "arrow.up.circle.fill",
                        colors: [.blue, .cyan],
                        action: { showUpdateView = true }
                    )
                    
                    LiquidGlassButton(
                        title: "Developer Center",
                        subtitle: "Info & External Links",
                        icon: "person.2.fill",
                        colors: [.purple, .blue],
                        action: { showInfoView = true }
                    )
                }
                .padding(.horizontal, 24)
                
                // Diagnostics Panel
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "waveform.path.ecg")
                            .foregroundColor(.cyan)
                        Text("SYSTEM STATUS")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.4))
                        Spacer()
                        Text("STABLE")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 8)
                    
                    VStack(spacing: 0) {
                        ModernStatusRow(label: "Bundle ID", value: Bundle.main.bundleIdentifier ?? "com.nezu.app", icon: "barcode")
                        Divider().background(Color.white.opacity(0.05)).padding(.horizontal, 12)
                        ModernStatusRow(label: "Local Debug", value: "ENABLED", icon: "ant.fill")
                        Divider().background(Color.white.opacity(0.05)).padding(.horizontal, 12)
                        ModernStatusRow(label: "Engine", value: "SwiftUI 6.0", icon: "cpu")
                    }
                    .background(.ultraThinMaterial)
                    .glassEffect(in: RoundedRectangle(cornerRadius: 24))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Components

struct LiquidGlassButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let colors: [Color]
    let action: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 50, height: 50)
                        .shadow(color: colors[0].opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .glassEffect(in: RoundedRectangle(cornerRadius: 28))
            .glassShimmer(animate: true)
            .scaleEffect(isHovering ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ModernStatusRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.cyan.opacity(0.8))
                .frame(width: 24)
            
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
    }
}

// MARK: - Shared UI (Liquid Glass)

struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.4))
                .frame(width: 400, height: 400)
                .offset(x: animate ? 100 : -100, y: animate ? -200 : -300)
            Circle()
                .fill(Color.purple.opacity(0.3))
                .frame(width: 500, height: 500)
                .offset(x: animate ? -150 : 180, y: animate ? 200 : 300)
            Circle()
                .fill(Color.cyan.opacity(0.2))
                .frame(width: 350, height: 350)
                .offset(x: animate ? 200 : -200, y: animate ? 300 : 100)
        }
        .blur(radius: 80)
        .onAppear {
            withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

extension View {
    /// デフォルト形状のグラスエフェクト（カプセル）
    @ViewBuilder
    func glassEffect() -> some View {
        glassEffect(in: Capsule())
    }
    
    /// 任意の Shape を指定できるグラスエフェクト
    @ViewBuilder
    func glassEffect<S: Shape>(in shape: S) -> some View {
        if #available(iOS 18.0, visionOS 2.0, *) {
            self.background(.glass, in: shape)
                .overlay(
                    shape
                        .stroke(.white.opacity(0.2), lineWidth: 0.5)
                        .blendMode(.overlay)
                )
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
    
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
}

// MARK: - Missing Liquid Glass Components

/// A premium container that provides the root structure for Liquid Glass interfaces.
struct GlassEffectContainer<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    
    init(spacing: CGFloat = 24, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .padding(.top, spacing)
        }
    }
}

/// Custom ShapeStyle extension to provide the luxury 'glass' look.
extension ShapeStyle where Self == AnyShapeStyle {
    static var glass: AnyShapeStyle {
        if #available(iOS 18.0, visionOS 2.0, *) {
            return AnyShapeStyle(.ultraThinMaterial.opacity(0.8))
        } else {
            return AnyShapeStyle(.ultraThinMaterial)
        }
    }
}
