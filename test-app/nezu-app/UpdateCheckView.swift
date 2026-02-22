//
//  UpdateView.swift
//  nezu-app
//
//  GitHub Releases から更新をチェックし、IPA をダウンロードする画面。
//

import SwiftUI

struct UpdateView: View {
    @StateObject private var updater = VersionManager()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Current version
                    VStack(spacing: 4) {
                        Text("現在のバージョン")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("v\(updater.currentVersion) (Build \(updater.currentBuild))")
                            .font(.title2.bold().monospaced())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Status
                    Group {
                        if updater.isLoading {
                            VStack(spacing: 12) {
                                ProgressView()
                                Text("確認中...")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            .glassEffect(in: .rect(cornerRadius: 16))
                        } else if let error = updater.error {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.orange)
                                Text(error)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .glassEffect(in: .rect(cornerRadius: 16))
                        } else if updater.hasUpdate, let latest = updater.latestVersion {
                            VStack(spacing: 16) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.green)

                                Text("新バージョン: v\(latest)")
                                    .font(.headline)

                                Button {
                                    updater.downloadIPA()
                                } label: {
                                    Label("IPA をダウンロード", systemImage: "square.and.arrow.down")
                                        .font(.body.bold())
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                }
                                .buttonStyle(.glass)

                                Text("SideStore で署名してインストール")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .glassEffect(in: .rect(cornerRadius: 16))
                        } else if updater.latestVersion != nil {
                            VStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.blue)
                                Text("最新バージョンです")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            .glassEffect(in: .rect(cornerRadius: 16))
                        }
                    }
                    .padding(.horizontal, 20)

                    // Check button
                    Button {
                        updater.checkForUpdates()
                    } label: {
                        Label("更新を確認", systemImage: "arrow.clockwise")
                            .font(.body.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(updater.isLoading)
                    .padding(.horizontal, 20)

                    // Source Management
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Source Repository")
                            .font(.headline)
                            .padding(.horizontal, 4)

                        Text("インストーラーにソースを追加すると、SideStore 等のアプリ一覧に Nezu App が表示され、自動更新が可能になります。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)

                        VStack(spacing: 12) {
                            sourceButton(title: "SideStore に追加", icon: "plus.circle.fill", scheme: "sidestore://source?url=https://nezumi0627.github.io/nezu-app/apps.json")
                            
                            sourceButton(title: "AltStore に追加", icon: "plus.circle.fill", scheme: "altstore://source?url=https://nezumi0627.github.io/nezu-app/apps.json")
                            
                            sourceButton(title: "LiveContainer に追加", icon: "shippingbox.fill", scheme: "livecontainer://source?url=aHR0cHM6Ly9uZXp1bWkwNjI3LmdpdGh1Yi5pby9uZXp1LWFwcC9hcHBzLmpzb24=")
                        }
                    }
                    .padding(20)
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("更新")
        }
        .onAppear {
            updater.checkForUpdates()
        }
    }

    @ViewBuilder
    private func sourceButton(title: String, icon: String, scheme: String) -> some View {
        Button {
            if let url = URL(string: scheme) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Label(title, systemImage: icon)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .font(.subheadline.bold())
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.primary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UpdateView()
}
