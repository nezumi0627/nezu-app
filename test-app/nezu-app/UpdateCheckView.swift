import SwiftUI

struct UpdateCheckView: View {
    @StateObject private var versionManager = VersionManager()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "020617").ignoresSafeArea()
                LiquidBackground()
                
                ScrollView {
                    GlassEffectContainer {
                        VStack(spacing: 20) {
                            // Header
                            VStack(spacing: 16) {
                                Image(systemName: "arrow.up.circle")
                                    .font(.system(size: 28, weight: .regular))
                                    .symbolVariant(.none)
                                    .foregroundStyle(.primary)
                                    .frame(width: 56, height: 56)
                                    .glassEffect(.interactive, in: Circle())
                                
                                VStack(spacing: 4) {
                                    Text("Software Update")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(.primary)
                                    
                                    Text(versionManager.isLoading ? "Checking for updates..." : "Update Status")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.top, 32)
                            
                            // Status
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
                            .padding(.horizontal, 20)
                            
                            // Refresh button
                            Button(action: { versionManager.checkForUpdates() }) {
                                HStack {
                                    if versionManager.isLoading {
                                        ProgressView()
                                            .tint(.primary)
                                    }
                                    Text(versionManager.isLoading ? "Checking..." : "Refresh")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
                            }
                            .disabled(versionManager.isLoading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                            .contentShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .medium))
                            .symbolVariant(.none)
                            .foregroundStyle(.secondary)
                            .frame(width: 32, height: 32)
                            .glassEffect(.interactive, in: Circle())
                    }
                    .contentShape(Circle())
                }
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
        VStack(spacing: 20) {
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
                
                Button(action: { versionManager.downloadIPA() }) {
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
        .padding(.vertical, 40)
        .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
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
