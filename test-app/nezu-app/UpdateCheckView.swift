import SwiftUI
#if os(iOS)
import UIKit
#endif

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
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 16) {
                                Text("バージョン情報")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.primary)
                                
                                Text("現在のバージョン: \(versionManager.currentVersionString) (\(versionManager.currentBuildString))")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.top, 32)
                            
                            // Status
                            VStack(spacing: 20) {
                                if versionManager.isLoading {
                                    VStack(spacing: 16) {
                                        ProgressView()
                                            .scaleEffect(1.2)
                                        Text("更新を確認中...")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
                                } else if let error = versionManager.errorMessage {
                                    VStack(spacing: 12) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .font(.system(size: 32))
                                            .foregroundStyle(.orange)
                                        Text("エラー: \(error)")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundStyle(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
                                } else if versionManager.updateAvailable {
                                    VStack(spacing: 20) {
                                        Text("新しいバージョンが利用可能です！")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(.green)
                                        
                                        if let latestVersion = versionManager.latestVersion {
                                            Text("最新バージョン: \(latestVersion)")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundStyle(.primary)
                                        }
                                        
                                        Button(action: {
                                            #if os(iOS)
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            #endif
                                            versionManager.downloadIPA()
                                        }) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "arrow.down.circle.fill")
                                                    .symbolVariant(.none)
                                                Text("IPAをダウンロード")
                                            }
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 14)
                                            .glassEffect(.interactive, in: Capsule())
                                        }
                                        .contentShape(Capsule())
                                        
                                        Text("※ダウンロード後、SideStoreで手動インストールしてください")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundStyle(.tertiary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 16)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 32)
                                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
                                } else if versionManager.latestVersion != nil {
                                    VStack(spacing: 12) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 32))
                                            .foregroundStyle(.blue)
                                        Text("最新バージョンを使用しています")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
                                }
                                
                                Button(action: {
                                    versionManager.checkForUpdates()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "arrow.clockwise")
                                            .symbolVariant(.none)
                                        Text("更新を確認")
                                    }
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 14)
                                    .glassEffect(.interactive, in: RoundedRectangle(cornerRadius: 16))
                                }
                                .disabled(versionManager.isLoading)
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .onAppear {
            versionManager.checkForUpdates()
        }
    }
}
