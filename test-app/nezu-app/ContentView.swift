//
//  ContentView.swift
//  nezu-app
//
//  メインのタブビュー。iOS 26 Liquid Glass デザイン。
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("ホーム", systemImage: "house.fill") {
                HomeView()
            }

            Tab("更新", systemImage: "arrow.clockwise") {
                UpdateView()
            }

            Tab("情報", systemImage: "info.circle") {
                InfoView()
            }
        }
    }
}

// MARK: - Home

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // App icon
                    Image(systemName: "app.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(.tint)
                        .frame(width: 100, height: 100)
                        .glassEffect(in: .circle)
                        .padding(.top, 40)

                    // App name & version
                    VStack(spacing: 6) {
                        Text("Nezu App")
                            .font(.largeTitle.bold())

                        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
                        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
                        Text("v\(version) (Build \(build))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Features
                    VStack(spacing: 0) {
                        FeatureRow(icon: "paintbrush.fill", title: "Liquid Glass", detail: "iOS 26 公式デザイン")
                        Divider().padding(.leading, 52)
                        FeatureRow(icon: "arrow.down.circle.fill", title: "OTA 更新", detail: "GitHub Releases から自動更新チェック")
                        Divider().padding(.leading, 52)
                        FeatureRow(icon: "hammer.fill", title: "自動ビルド", detail: "GitHub Actions で署名無し IPA を生成")
                    }
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .padding(.horizontal, 20)

                    // Device info
                    VStack(spacing: 0) {
                        #if os(iOS)
                        InfoRow(label: "デバイス", value: UIDevice.current.model)
                        Divider().padding(.leading, 16)
                        InfoRow(label: "iOS", value: UIDevice.current.systemVersion)
                        Divider().padding(.leading, 16)
                        #endif
                        InfoRow(label: "Bundle ID", value: Bundle.main.bundleIdentifier ?? "-")
                    }
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Nezu App")
        }
    }
}

// MARK: - Components

struct FeatureRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.tint)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.body.weight(.medium).monospaced())
        }
        .font(.subheadline)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    ContentView()
}
