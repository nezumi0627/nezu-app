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
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 32, weight: .light))
                                .foregroundStyle(.primary)
                                .padding(16)
                                .glassEffect(in: Circle())
                            
                            Text("Software Update")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.primary)
                            
                            Text("Checking for updates...")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 40)
                        
                        // Status
                        VStack {
                            if versionManager.isLoading {
                                LoadingView()
                            } else if let error = versionManager.errorMessage {
                                ErrorView(message: error)
                            } else if versionManager.updateAvailable {
                                UpdateAvailableView(versionManager: versionManager)
                            } else {
                                UpToDateView(version: versionManager.currentVersion)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Refresh button
                        Button(action: { versionManager.checkForUpdates() }) {
                            HStack {
                                if versionManager.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                }
                                Text(versionManager.isLoading ? "Checking..." : "Refresh")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .glassEffect(in: RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(versionManager.isLoading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
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
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .glassEffect(in: RoundedRectangle(cornerRadius: 12))
    }
}

struct UpdateAvailableView: View {
    @ObservedObject var versionManager: VersionManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Update Available")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
            
            Text(versionManager.latestVersion ?? "Unknown")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(.primary)
            
            Button(action: { versionManager.downloadIPA() }) {
                HStack {
                    Image(systemName: "arrow.down.circle")
                    Text("Download")
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(.blue, in: Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .glassEffect(in: RoundedRectangle(cornerRadius: 12))
    }
}

struct UpToDateView: View {
    let version: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.green)
            
            Text("Up to Date")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)
            
            Text("v\(version)")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .glassEffect(in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundStyle(.orange)
            
            Text(message)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .glassEffect(in: RoundedRectangle(cornerRadius: 12))
    }
}
