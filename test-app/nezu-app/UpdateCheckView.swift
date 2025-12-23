//
//  UpdateCheckView.swift
//  test-app
//
//  Created by GitHub Actions
//

import SwiftUI

struct UpdateCheckView: View {
    @StateObject private var versionManager = VersionManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("バージョン情報")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("現在のバージョン: \(versionManager.currentVersion)")
                .font(.body)
            
            if versionManager.isLoading {
                ProgressView()
                    .padding()
            } else if let error = versionManager.errorMessage {
                Text("エラー: \(error)")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            } else if versionManager.updateAvailable {
                VStack(spacing: 15) {
                    Text("新しいバージョンが利用可能です！")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    if let latestVersion = versionManager.latestVersion {
                        Text("最新バージョン: \(latestVersion)")
                            .font(.subheadline)
                    }
                    
                    Button(action: {
                        versionManager.downloadIPA()
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("IPAをダウンロード")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
                    Text("※ダウンロード後、SideStoreで手動インストールしてください")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            } else if versionManager.latestVersion != nil {
                Text("最新バージョンを使用しています")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
            
            Button(action: {
                versionManager.checkForUpdates()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("更新を確認")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
            }
            .disabled(versionManager.isLoading)
        }
        .padding()
    }
}

struct UpdateCheckView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateCheckView()
    }
}

