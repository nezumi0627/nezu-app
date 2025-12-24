import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Updatesタブ用のLiquid Glass UI
struct UpdateCheckView: View {
    @StateObject private var versionManager = VersionManager()
    
    var body: some View {
        ScrollView {
            GlassEffectContainer {
                VStack(spacing: 20) {
                    // ヘッダー
                    GlassEffectContainer {
                        VStack(spacing: 10) {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 26, weight: .regular))
                                .foregroundStyle(.primary)
                                .frame(width: 52, height: 52)
                                .glassEffect(.interactive, in: Circle())
                            
                            VStack(spacing: 2) {
                                Text("Software Update")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.primary)
                                
                                Text(versionManager.isLoading ? "Checking for updates..." : "Latest release status")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 18)
                    }
                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 18))
                    
                    // 状態カード
                    GlassEffectContainer {
                        VStack {
                            if versionManager.isLoading {
                                LoadingView()
                            } else if let error = versionManager.errorMessage {
                                ErrorView(message: error)
                            } else if versionManager.updateAvailable {
                                UpdateAvailableView(versionManager: versionManager)
                            } else {
                                UpToDateView(versionManager: versionManager)
                            }
                        }
                        .padding(16)
                    }
                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 18))
                    
                    // アクションボタン
                    GlassEffectContainer {
                        VStack(spacing: 10) {
                            Button {
                                #if os(iOS)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                #endif
                                versionManager.checkForUpdates()
                            } label: {
                                HStack(spacing: 8) {
                                    if versionManager.isLoading {
                                        ProgressView()
                                            .tint(.primary)
                                    }
                                    Text(versionManager.isLoading ? "Checking..." : "Check Again")
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                            }
                            .buttonStyle(.plain)
                            .disabled(versionManager.isLoading)
                            .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 14))
                            
                            Text("Checks the latest draft or published release on GitHub and compares it with the current app version.")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(14)
                    }
                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 18))
                    
                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            versionManager.checkForUpdates()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Checking for updates...")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct UpdateAvailableView: View {
    @ObservedObject var versionManager: VersionManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Update Available")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 6) {
                Text(versionManager.latestVersion ?? "Unknown")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.primary)
                
                if let build = versionManager.latestBuild {
                    Text("Build \(build)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.secondary)
                }
            }
            
            VStack(spacing: 12) {
                Text("Current: v\(versionManager.currentVersionString) (\(versionManager.currentBuildString))")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.tertiary)
                
                Button {
                    #if os(iOS)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    #endif
                    versionManager.downloadIPA()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.circle")
                            .symbolVariant(.none)
                        Text("Download")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .glassEffect(.interactive, in: Capsule())
                }
                .contentShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 14))
    }
}

struct UpToDateView: View {
    @ObservedObject var versionManager: VersionManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .symbolVariant(.none)
                .foregroundStyle(.green)
            
            Text("Up to Date")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 6) {
                Text("v\(versionManager.currentVersionString)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                Text("Build \(versionManager.currentBuildString)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .symbolVariant(.none)
                .foregroundStyle(.orange)
            
            Text(message)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
    }
}
