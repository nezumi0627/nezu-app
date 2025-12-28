import SwiftUI

struct ContentView: View {
    @State private var showUpdateView = false
    @State private var showInfoView = false
    @StateObject private var versionManager = VersionManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(hex: "020617").ignoresSafeArea()
                LiquidBackground()
                
                ScrollView {
                    GlassEffectContainer {
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 16) {
                                Image(systemName: "app.dashed")
                                    .font(.system(size: 48, weight: .regular))
                                    .symbolVariant(.none)
                                    .foregroundStyle(.primary)
                                    .frame(width: 80, height: 80)
                                    .glassEffect(.interactive, in: Circle())
                                
                                VStack(spacing: 8) {
                                    Text("Nezu App")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundStyle(.primary)
                                    
                                    HStack(spacing: 6) {
                                        Image(systemName: "info.circle.fill")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                        Text("Version \(versionManager.currentVersionString) (\(versionManager.currentBuildString))")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .glassEffect(.interactive, in: Capsule())
                                }
                            }
                            .padding(.top, 40)
                            
                            // Action Buttons
                            VStack(spacing: 12) {
                                ActionButton(
                                    title: "開発者情報",
                                    icon: "person.circle.fill",
                                    action: { showInfoView = true }
                                )
                                
                                ActionButton(
                                    title: "更新を確認",
                                    icon: "arrow.clockwise.circle.fill",
                                    action: { showUpdateView = true }
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            // Debug Info
                            VStack(alignment: .leading, spacing: 12) {
                                Text("デバッグ情報")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.secondary)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    DebugInfoRow(label: "Bundle ID", value: Bundle.main.bundleIdentifier ?? "N/A")
                                    DebugInfoRow(label: "Build", value: versionManager.currentBuildString)
                                    DebugInfoRow(label: "Version", value: versionManager.currentVersionString)
                                    
                                    #if os(iOS)
                                    DebugInfoRow(label: "iOS Version", value: UIDevice.current.systemVersion)
                                    DebugInfoRow(label: "Device", value: UIDevice.current.model)
                                    #endif
                                }
                            }
                            .padding(16)
                            .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showInfoView) {
                InfoView()
            }
            .sheet(isPresented: $showUpdateView) {
                UpdateCheckView()
            }
        }
    }
}

// MARK: - Components

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            #endif
            action()
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .symbolVariant(.none)
                    .foregroundStyle(.primary)
                    .frame(width: 32, height: 32)
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .symbolVariant(.none)
                    .foregroundStyle(.tertiary)
            }
            .padding(18)
            .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct DebugInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Background

struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue.opacity(0.08),
                            Color.cyan.opacity(0.05),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 400
                    )
                )
                .frame(width: 500, height: 500)
                .offset(x: animate ? 50 : -50, y: animate ? -100 : -150)
                .blur(radius: 100)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.06),
                            Color.clear
                        ],
                        center: .bottomTrailing,
                        startRadius: 0,
                        endRadius: 350
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: animate ? -80 : 80, y: animate ? 120 : 150)
                .blur(radius: 90)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

// MARK: - Extensions

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
