//
//  ContentView.swift
//  nezu-app
//
//  Created by GitHub Actions
//

import SwiftUI

struct ContentView: View {
    @State private var showUpdateView = false
    @State private var showInfoView = false
    @StateObject private var versionManager = VersionManager()
    
    var currentVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(version).\(build)"
        }
        return "1.0.1"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // アプリ名
                VStack(spacing: 10) {
                    Text("Nezu App")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // バージョン表示
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Version \(currentVersion)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                // クイックアクションボタン
                VStack(spacing: 16) {
                    ActionButton(
                        title: "開発者情報",
                        icon: "person.circle.fill",
                        color: .blue
                    ) {
                        showInfoView = true
                    }
                    
                    ActionButton(
                        title: "更新を確認",
                        icon: "arrow.clockwise.circle.fill",
                        color: .green
                    ) {
                        showUpdateView = true
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // デバッグ情報
                VStack(spacing: 8) {
                    Text("デバッグ情報")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        DebugInfoRow(label: "Bundle ID", value: Bundle.main.bundleIdentifier ?? "N/A")
                        DebugInfoRow(label: "Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A")
                        DebugInfoRow(label: "Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A")
                    }
                    .font(.caption)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showInfoView = true
                    }) {
                        Image(systemName: "person.circle")
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showUpdateView = true
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showInfoView) {
                NavigationView {
                    InfoView()
                        .navigationTitle("開発者情報")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("閉じる") {
                                    showInfoView = false
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $showUpdateView) {
                NavigationView {
                    UpdateCheckView()
                        .navigationTitle("バージョン情報")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("閉じる") {
                                    showUpdateView = false
                                }
                            }
                        }
                }
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.white)
            .padding()
            .background(color)
            .cornerRadius(12)
        }
    }
}

struct DebugInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
                .fontWeight(.medium)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

