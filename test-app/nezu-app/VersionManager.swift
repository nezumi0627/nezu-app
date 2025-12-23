import Foundation
import Combine
#if os(iOS)
import UIKit
#endif

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

@MainActor
class VersionManager: ObservableObject {
    @Published var currentVersion: String = "1.0.1"
    @Published var latestVersion: String?
    @Published var updateAvailable: Bool = false
    @Published var downloadUrl: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let githubRepo = "nezumi0627/nezu-app"
    private let apiBaseUrl = "https://api.github.com/repos"
    
    init() {
        #if os(iOS)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            self.currentVersion = "\(version).\(build)"
        }
        #endif
    }
    
    func checkForUpdates() {
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(apiBaseUrl)/\(githubRepo)/releases"
        guard let url = URL(string: urlString) else {
            errorMessage = "無効なURLです"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            let receivedData = data
            let receivedError = error
            
            Task { @MainActor in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = receivedError {
                    self.errorMessage = "エラー: \(error.localizedDescription)"
                    return
                }
                
                guard let data = receivedData else {
                    self.errorMessage = "データの取得に失敗しました"
                    return
                }
                
                self.processReleaseData(data)
            }
        }.resume()
    }

    private func processReleaseData(_ data: Data) {
        do {
            let releases = try JSONDecoder().decode([ReleaseInfo].self, from: data)
            let draftReleases = releases.filter { $0.draft }
            let availableReleases = draftReleases.isEmpty ? releases : draftReleases
            
            guard let latestRelease = availableReleases.first else {
                self.errorMessage = "利用可能なリリースが見つかりません"
                return
            }
            
            let tagVersion = self.extractVersionFromTag(latestRelease.tagName)
            
            if let ipaAsset = latestRelease.assets.first(where: { $0.name.hasSuffix(".ipa") }) {
                self.latestVersion = tagVersion
                self.downloadUrl = ipaAsset.browserDownloadUrl
                updateCompareLogic(tagVersion: tagVersion)
            } else {
                self.errorMessage = "IPAファイルが見つかりません"
            }
        } catch {
            self.errorMessage = "データの解析に失敗しました"
        }
    }

    private func updateCompareLogic(tagVersion: String) {
        let currentBuildStr = self.currentVersion.components(separatedBy: ".").last ?? "1"
        if let currentBuild = Int(currentBuildStr),
           let latestBuild = Int(tagVersion) {
            self.updateAvailable = latestBuild > currentBuild
        } else {
            self.updateAvailable = tagVersion != self.currentVersion
        }
    }
    
    private func extractVersionFromTag(_ tag: String) -> String {
        let components = tag.components(separatedBy: "-")
        if components.count >= 2 {
            return components[1]
        }
        return tag
    }
    
    func downloadIPA() {
        guard let downloadUrl = downloadUrl,
              let url = URL(string: downloadUrl) else {
            errorMessage = "ダウンロードURLが無効です"
            return
        }
        
        #if os(iOS)
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            errorMessage = "ダウンロードを開始できませんでした"
        }
        #endif
    }
}
