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
                    .glassEffect(in: .rect(cornerRadius: 24)) // Liquid Glass modifier
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

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
            .glassEffect(in: .rect(cornerRadius: 28))
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


struct GlassActionButton: View {
    let title: String
    let icon: String
    let colors: [Color]
    let action: () -> Void
    
    @State private var isPressing = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.system(.headline, design: .rounded))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .opacity(0.5)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 1
                        )
                }
            )
            .scaleEffect(isPressing ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressing)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            _ = self.isPressing // touch observation simulated
        }
    }
}

struct ModernDebugRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)
        }
    }
}

struct AnimatedGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 300)
                .offset(x: animate ? 100 : -100, y: animate ? -200 : 200)
            
            Circle()
                .fill(Color.purple.opacity(0.2))
                .frame(width: 400)
                .offset(x: animate ? -150 : 150, y: animate ? 250 : -250)
        }
        .blur(radius: 100)
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}


