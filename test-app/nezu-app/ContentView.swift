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
                
                // Subtle background gradient
                LiquidBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "app.dashed")
                                .font(.system(size: 32, weight: .light))
                                .foregroundStyle(.primary)
                                .padding(16)
                                .glassEffect(in: Circle())
                            
                            Text("Nezu App")
                                .font(.system(size: 28, weight: .semibold, design: .default))
                                .foregroundStyle(.primary)
                            
                            Text("IPA Management")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 40)
                        
                        // Actions
                        VStack(spacing: 12) {
                            ActionButton(
                                title: "Check for Updates",
                                subtitle: "v\(versionManager.currentVersion)",
                                icon: "arrow.up.circle",
                                action: { showUpdateView = true }
                            )
                            
                            ActionButton(
                                title: "Developer Info",
                                subtitle: "About & Links",
                                icon: "person.circle",
                                action: { showInfoView = true }
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Status
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Status")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("Ready")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.green.opacity(0.15), in: Capsule())
                            }
                            
                            Divider()
                            
                            StatusRow(label: "Bundle ID", value: Bundle.main.bundleIdentifier ?? "com.nezu.app")
                            StatusRow(label: "Version", value: versionManager.currentVersion)
                        }
                        .padding(16)
                        .glassEffect(in: RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
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
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .glassEffect(in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
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
                .fill(Color.blue.opacity(0.15))
                .frame(width: 300, height: 300)
                .offset(x: animate ? 50 : -50, y: animate ? -100 : -150)
            Circle()
                .fill(Color.purple.opacity(0.1))
                .frame(width: 400, height: 400)
                .offset(x: animate ? -75 : 90, y: animate ? 100 : 150)
        }
        .blur(radius: 60)
        .onAppear {
            withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

// MARK: - Extensions

extension View {
    @ViewBuilder
    func glassEffect<S: Shape>(in shape: S) -> some View {
        if #available(iOS 18.0, visionOS 2.0, *) {
            self.background(.glass, in: shape)
        } else {
            self.background(.ultraThinMaterial, in: shape)
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
    
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
}
