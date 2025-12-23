//
//  VersionManager.swift
//  test-app
//
//  Created by GitHub Actions
//

import Foundation
import UIKit

struct ReleaseInfo: Codable {
    let tagName: String
    let name: String
    let draft: Bool
    let assets: [Asset]
    let publishedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case name
        case draft
        case assets
        case publishedAt = "published_at"
    }
}

struct Asset: Codable {
    let name: String
    let browserDownloadUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case browserDownloadUrl = "browser_download_url"
    }
}

class VersionManager: ObservableObject {
    @Published var currentVersion: String
    @Published var latestVersion: String?
    @Published var updateAvailable: Bool = false
    @Published var downloadUrl: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let githubRepo = "nezumi0627/ipa-builder"
    private let apiBaseUrl = "https://api.github.com/repos"
    
    init() {
        // 現在のバージョンを取得
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            self.currentVersion = "\(version).\(build)"
        } else {
            self.currentVersion = "1.0.1"
        }
    }
    
    func checkForUpdates() {
        isLoading = true
        errorMessage = nil
        
        // GitHub Releases APIから最新のDraft Releaseを取得
        let urlString = "\(apiBaseUrl)/\(githubRepo)/releases"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "無効なURLです"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "エラー: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "データの取得に失敗しました"
                    return
                }
                
                do {
                    let releases = try JSONDecoder().decode([ReleaseInfo].self, from: data)
                    
                    // Draft Releaseを探す（最新のもの）
                    let draftReleases = releases.filter { $0.draft }
                    
                    // Draft Releaseがない場合は、通常のReleaseを探す
                    let availableReleases = draftReleases.isEmpty ? releases : draftReleases
                    
                    guard let latestRelease = availableReleases.first else {
                        self?.errorMessage = "利用可能なリリースが見つかりません。GitHub Actionsでビルドが完了するまでお待ちください。"
                        return
                    }
                    
                    // タグ名からバージョン情報を抽出（例: build-5-abc1234 -> 5）
                    let tagVersion = self?.extractVersionFromTag(latestRelease.tagName) ?? ""
                    
                    // IPAファイルを探す
                    if let ipaAsset = latestRelease.assets.first(where: { $0.name.hasSuffix(".ipa") }) {
                        self?.latestVersion = tagVersion
                        self?.downloadUrl = ipaAsset.browserDownloadUrl
                        
                        // バージョン比較（簡易版：タグ名のビルド番号で比較）
                        if let currentBuild = Int(self?.currentVersion.components(separatedBy: ".").last ?? "1"),
                           let latestBuild = Int(tagVersion) {
                            self?.updateAvailable = latestBuild > currentBuild
                        } else {
                            // 文字列比較（フォールバック）
                            self?.updateAvailable = tagVersion != self?.currentVersion
                        }
                    } else {
                        self?.errorMessage = "IPAファイルが見つかりません"
                    }
                } catch {
                    self?.errorMessage = "データの解析に失敗しました: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func extractVersionFromTag(_ tag: String) -> String {
        // build-5-abc1234 から 5 を抽出
        let components = tag.components(separatedBy: "-")
        if components.count >= 2, let buildNumber = components[1] as String? {
            return buildNumber
        }
        return tag
    }
    
    func downloadIPA() {
        guard let downloadUrl = downloadUrl,
              let url = URL(string: downloadUrl) else {
            errorMessage = "ダウンロードURLが無効です"
            return
        }
        
        // Safariでダウンロードページを開く
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            errorMessage = "ダウンロードを開始できません"
        }
    }
}

