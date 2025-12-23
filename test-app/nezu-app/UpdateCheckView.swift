import SwiftUI

struct UpdateCheckView: View {
    @StateObject private var versionManager = VersionManager()
    @Environment(\.dismiss) var dismiss
    @State private var startAnimation = false
    
    var body: some View {
        ZStack {
            // Premium Background
            Color(hex: "020617").ignoresSafeArea()
            LiquidBackground()
            
            // Root Liquid Glass Container
            if #available(iOS 18.0, visionOS 2.0, *) {
                GlassEffectContainer(spacing: 30) {
                    updateContent
                }
            } else {
                updateContent
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                startAnimation = true
            }
            versionManager.checkForUpdates()
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .glassEffect(in: .circle)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private var updateContent: some View {
        VStack(spacing: 32) {
            // Animated Header
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .frame(width: 120, height: 120)
                        .glassEffect()
                        .glassShimmer(animate: true)
                    
                    Image(systemName: "arrow.up.square.fill")
                        .font(.system(size: 70, weight: .thin))
                        .foregroundStyle(
                            LinearGradient(colors: [.white, .blue.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .shadow(color: .blue.opacity(0.5), radius: 15, x: 0, y: 10)
                }
                .scaleEffect(startAnimation ? 1.0 : 0.8)
                .rotationEffect(.degrees(startAnimation ? 0 : -10))
                
                VStack(spacing: 4) {
                    Text("Software Update")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Checking for latest build...")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(.top, 40)
            
            // Status Box
            VStack {
                if versionManager.isLoading {
                    PremiumLoadingView()
                } else if let error = versionManager.errorMessage {
                    PremiumErrorView(message: error)
                } else if versionManager.updateAvailable {
                    PremiumUpdateCard(versionManager: versionManager)
                } else {
                    PremiumUpToDateView(version: versionManager.currentVersion)
                }
            }
            .padding(.horizontal, 24)
            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
            
            Spacer()
            
            // Refresh Action
            Button(action: { versionManager.checkForUpdates() }) {
                HStack {
                    if versionManager.isLoading {
                        ProgressView().tint(.white).padding(.trailing, 8)
                    }
                    Text(versionManager.isLoading ? "SECURE CHECK..." : "FORCE REFRESH")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    ZStack {
                        if versionManager.isLoading {
                            Color.white.opacity(0.1)
                        } else {
                            LinearGradient(colors: [.blue, .blue.opacity(0.6)], startPoint: .leading, endPoint: .trailing)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .blue.opacity(versionManager.isLoading ? 0 : 0.3), radius: 20, y: 10)
            }
            .disabled(versionManager.isLoading)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

struct PremiumLoadingView: View {
    @State private var rotate = false
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 4)
                    .frame(width: 60, height: 60)
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(LinearGradient(colors: [.cyan, .blue], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotate ? 360 : 0))
            }
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotate = true
                }
            }
            
            Text("SYNCHRONIZING RELEASES")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .glassEffect(in: .rect(cornerRadius: 32))
        .glassShimmer(animate: true)
    }
}

struct PremiumUpdateCard: View {
    @ObservedObject var versionManager: VersionManager
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("RELEASE DETECTED")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.cyan)
                
                Text(versionManager.latestVersion ?? "Unknown")
                    .font(.system(size: 50, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Button(action: { versionManager.downloadIPA() }) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.app.fill")
                    Text("INSTALL UPDATE")
                }
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.white.opacity(0.1))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
            }
            
            Text("Target: iOS Binary (IPA)")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .glassEffect(in: .rect(cornerRadius: 32))
        .glassShimmer(animate: true)
    }
}

struct PremiumUpToDateView: View {
    let version: String
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 50))
                .foregroundStyle(LinearGradient(colors: [.green, .emerald], startPoint: .top, endPoint: .bottom))
            
            VStack(spacing: 4) {
                Text("System Up to Date")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("v\(version) is the latest stable build")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .glassEffect(in: .rect(cornerRadius: 32))
        .glassShimmer(animate: true)
    }
}

struct PremiumErrorView: View {
    let message: String
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.shield.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .glassEffect(in: .rect(cornerRadius: 32))
        .glassShimmer(animate: true)
    }
}
