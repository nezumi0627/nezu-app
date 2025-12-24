import SwiftUI
#if os(iOS)
import UIKit
#endif

struct ContentView: View {
    // 画面タブ
    enum Tab {
        case home
        case updates
        case info
    }
    
    @State private var selectedTab: Tab = .home
    @StateObject private var versionManager = VersionManager()
    
    var body: some View {
        ZStack {
            // 共通背景
            Color(hex: "020617").ignoresSafeArea()
            LiquidBackground()
            
            VStack(spacing: 0) {
                // メインコンテンツ
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(selectedTab: $selectedTab, versionManager: versionManager)
                    case .updates:
                        UpdateCheckView()
                    case .info:
                        InfoView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                // 下部ドック（Liquid Glass）
                DockView(selectedTab: $selectedTab, versionManager: versionManager)
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
        Button {
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
            action()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .symbolVariant(.none)
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                
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

struct StatusRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Home Screen

struct HomeView: View {
    @Binding var selectedTab: ContentView.Tab
    @ObservedObject var versionManager: VersionManager
    
    var body: some View {
        ScrollView {
            GlassEffectContainer {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "app.dashed")
                            .font(.system(size: 24, weight: .regular))
                            .symbolVariant(.none)
                            .foregroundStyle(.primary)
                            .frame(width: 48, height: 48)
                            .glassEffect(.interactive, in: Circle())
                        
                        VStack(spacing: 2) {
                            Text("Nezu App")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.primary)
                            
                            Text("IPA Management")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Actions
                    VStack(spacing: 10) {
                        ActionButton(
                            title: "Check for Updates",
                            subtitle: "v\(versionManager.currentVersionString) (\(versionManager.currentBuildString))",
                            icon: "arrow.up.circle",
                            action: {
                                selectedTab = .updates
                            }
                        )
                        
                        ActionButton(
                            title: "Developer Info",
                            subtitle: "About & Links",
                            icon: "person.circle",
                            action: {
                                selectedTab = .info
                            }
                        )
                    }
                    .padding(.horizontal, 16)
                    
                    // Status
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Status")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("Ready")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .glassEffect(.interactive, in: Capsule())
                        }
                        
                        Divider()
                            .background(.quaternary)
                        
                        StatusRow(label: "Bundle ID", value: Bundle.main.bundleIdentifier ?? "com.nezu.app")
                        StatusRow(label: "Version", value: versionManager.currentVersionString)
                        StatusRow(label: "Build", value: versionManager.currentBuildString)
                        
                        #if os(iOS)
                        StatusRow(label: "iOS Version", value: UIDevice.current.systemVersion)
                        StatusRow(label: "Device", value: UIDevice.current.model)
                        #endif
                        
                        if let fullVersion = versionManager.currentVersion?.fullVersionString {
                            StatusRow(label: "Full Version", value: fullVersion)
                        }
                    }
                    .padding(16)
                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

// MARK: - Dock

struct DockView: View {
    @Binding var selectedTab: ContentView.Tab
    @ObservedObject var versionManager: VersionManager
    
    var body: some View {
        VStack(spacing: 8) {
            Divider()
                .overlay(Color.white.opacity(0.08))
            
            GlassEffectContainer {
                HStack(spacing: 18) {
                    DockItem(
                        systemName: "house.fill",
                        title: "Home",
                        isSelected: selectedTab == .home
                    ) {
                        selectedTab = .home
                    }
                    
                    DockItem(
                        systemName: "arrow.up.circle.fill",
                        title: "Updates",
                        isSelected: selectedTab == .updates
                    ) {
                        selectedTab = .updates
                    }
                    
                    DockItem(
                        systemName: "person.crop.circle",
                        title: "Info",
                        isSelected: selectedTab == .info
                    ) {
                        selectedTab = .info
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .glassEffect(.interactive, in: Capsule())
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        .background(
            Color.black.opacity(0.1)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct DockItem: View {
    let systemName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            #endif
            action()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.system(size: 16, weight: .semibold))
                    .symbolVariant(.none)
                    .foregroundStyle(isSelected ? .primary : .secondary)
                
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}

// MARK: - Background

struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // シンプルなグラデーション背景
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
    
    static let emerald = Color(red: 16/255, green: 185/255, blue: 129/255)
}
