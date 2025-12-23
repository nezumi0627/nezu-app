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

struct AppVersion {
    let major: Int
    let minor: Int
    let patch: Int
    let build: Int
    
    var versionString: String {
        "\(major).\(minor).\(patch)"
    }
    
    var fullVersionString: String {
        "\(major).\(minor).\(patch).\(build)"
    }
    
    init?(versionString: String, buildString: String) {
        let versionComponents = versionString.components(separatedBy: ".").compactMap { Int($0) }
        guard versionComponents.count >= 2 else { return nil }
        
        self.major = versionComponents[0]
        self.minor = versionComponents.count > 1 ? versionComponents[1] : 0
        self.patch = versionComponents.count > 2 ? versionComponents[2] : 0
        self.build = Int(buildString) ?? 0
    }
    
    func compare(to other: AppVersion) -> ComparisonResult {
        if major != other.major {
            return major > other.major ? .orderedDescending : .orderedAscending
        }
        if minor != other.minor {
            return minor > other.minor ? .orderedDescending : .orderedAscending
        }
        if patch != other.patch {
            return patch > other.patch ? .orderedDescending : .orderedAscending
        }
        if build != other.build {
            return build > other.build ? .orderedDescending : .orderedAscending
        }
        return .orderedSame
    }
}

@MainActor
class VersionManager: ObservableObject {
    @Published var currentVersion: AppVersion?
    @Published var currentVersionString: String = "1.0.0"
    @Published var currentBuildString: String = "1"
    @Published var latestVersion: String?
    @Published var latestBuild: Int?
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
            self.currentVersionString = version
            self.currentBuildString = build
            self.currentVersion = AppVersion(versionString: version, buildString: build)
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
            
            // Draftリリースを除外し、publishedリリースのみをチェック
            let publishedReleases = releases.filter { !$0.draft && $0.publishedAt != nil }
            
            guard let latestRelease = publishedReleases.first else {
                self.errorMessage = "利用可能なリリースが見つかりません"
                return
            }
            
            // タグ名からバージョン情報を抽出
            let (versionString, buildNumber) = self.extractVersionFromTag(latestRelease.tagName)
            
            if let ipaAsset = latestRelease.assets.first(where: { $0.name.hasSuffix(".ipa") }) {
                self.latestVersion = versionString
                self.latestBuild = buildNumber
                self.downloadUrl = ipaAsset.browserDownloadUrl
                updateCompareLogic(latestVersionString: versionString, latestBuild: buildNumber)
            } else {
                self.errorMessage = "IPAファイルが見つかりません"
            }
        } catch {
            self.errorMessage = "データの解析に失敗しました: \(error.localizedDescription)"
        }
    }

    private func updateCompareLogic(latestVersionString: String, latestBuild: Int?) {
        guard let currentVersion = self.currentVersion else {
            // 現在のバージョンが取得できない場合は比較しない
            self.updateAvailable = false
            return
        }
        
        // 最新リリースのバージョンを解析
        guard let latestVersion = AppVersion(
            versionString: latestVersionString,
            buildString: latestBuild.map { String($0) } ?? "0"
        ) else {
            // バージョン解析に失敗した場合は比較しない
            self.updateAvailable = false
            return
        }
        
        // バージョン比較（最新が現在より新しい場合のみ更新あり）
        let comparison = currentVersion.compare(to: latestVersion)
        self.updateAvailable = comparison == .orderedAscending
    }
    
    private func extractVersionFromTag(_ tag: String) -> (versionString: String, buildNumber: Int?) {
        // untagged-{COMMIT_HASH}形式の場合
        if tag.hasPrefix("untagged-") {
            // untaggedリリースの場合は、リリース名からバージョンを抽出を試みる
            // または、ビルド番号のみを使用
            return (self.currentVersionString, nil)
        }
        
        // build-{BUILD_NUMBER}-{COMMIT_HASH}形式の場合
        let components = tag.components(separatedBy: "-")
        if components.count >= 2, let buildNumber = Int(components[1]) {
            // ビルド番号からバージョンを推定（現在のバージョン形式を維持）
            return (self.currentVersionString, buildNumber)
        }
        
        // v{MAJOR}.{MINOR}.{PATCH}形式の場合
        if tag.hasPrefix("v") {
            let versionString = String(tag.dropFirst())
            return (versionString, nil)
        }
        
        // その他の形式
        return (tag, nil)
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
