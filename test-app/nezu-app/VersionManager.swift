//
//  VersionManager.swift
//  nezu-app
//
//  GitHub Releases API から最新バージョンを取得し、
//  現在のアプリバージョンと比較する。
//

import SwiftUI

@MainActor
class VersionManager: ObservableObject {
    @Published var isLoading = false
    @Published var hasUpdate = false
    @Published var latestVersion: String?
    @Published var downloadURL: URL?
    @Published var error: String?

    var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var currentBuild: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    private let apiURL = "https://api.github.com/repos/nezumi0627/nezu-app/releases"

    // MARK: - Check for updates

    func checkForUpdates() {
        guard !isLoading else { return }

        isLoading = true
        hasUpdate = false
        latestVersion = nil
        downloadURL = nil
        error = nil

        Task {
            do {
                guard let url = URL(string: apiURL) else {
                    throw UpdateError.invalidURL
                }

                var request = URLRequest(url: url)
                request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
                request.timeoutInterval = 15

                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw UpdateError.serverError
                }

                let releases = try JSONDecoder().decode([Release].self, from: data)

                // Draft 以外で IPA を含むリリースを取得
                let valid = releases
                    .filter { !$0.draft }
                    .filter { $0.assets.contains { $0.name.hasSuffix(".ipa") } }
                    .sorted { $0.publishedAt > $1.publishedAt }

                guard let latest = valid.first else {
                    throw UpdateError.noRelease
                }

                let remoteVersion = parseVersion(from: latest.tagName)
                latestVersion = remoteVersion

                if let ipa = latest.assets.first(where: { $0.name.hasSuffix(".ipa") }) {
                    downloadURL = URL(string: ipa.browserDownloadURL)
                }

                hasUpdate = isNewer(remote: remoteVersion, local: currentVersion, remoteBuild: parseBuild(from: latest.tagName), localBuild: currentBuild)
                isLoading = false

            } catch {
                self.error = error.localizedDescription
                isLoading = false
            }
        }
    }

    // MARK: - Download

    func downloadIPA() {
        guard let url = downloadURL else { return }
        #if os(iOS)
        UIApplication.shared.open(url)
        #else
        print("Download URL: \(url)")
        #endif
    }

    // MARK: - Version parsing

    private func parseVersion(from tag: String) -> String {
        // v1.2.0-build3 → 1.2.0
        if tag.hasPrefix("v") {
            let stripped = String(tag.dropFirst())
            if let dash = stripped.firstIndex(of: "-") {
                return String(stripped[stripped.startIndex..<dash])
            }
            return stripped
        }
        // build-22-abc1234 → ビルド番号のみ
        if let match = tag.range(of: #"build-(\d+)"#, options: .regularExpression) {
            return String(tag[match])
        }
        return tag
    }

    private func parseBuild(from tag: String) -> String {
        // v1.2.0-build3 → 3
        if let range = tag.range(of: #"build(\d+)"#, options: .regularExpression) {
            let sub = tag[range]
            return String(sub.dropFirst(5))
        }
        // build-22 → 22
        if let range = tag.range(of: #"build-(\d+)"#, options: .regularExpression) {
            let sub = tag[range]
            return String(sub.dropFirst(6))
        }
        return "0"
    }

    private func isNewer(remote: String, local: String, remoteBuild: String, localBuild: String) -> Bool {
        let rv = versionComponents(remote)
        let lv = versionComponents(local)

        for i in 0..<max(rv.count, lv.count) {
            let r = i < rv.count ? rv[i] : 0
            let l = i < lv.count ? lv[i] : 0
            if r > l { return true }
            if r < l { return false }
        }

        // バージョンが同じならビルド番号で比較
        let rb = Int(remoteBuild) ?? 0
        let lb = Int(localBuild) ?? 0
        return rb > lb
    }

    private func versionComponents(_ version: String) -> [Int] {
        version.split(separator: ".").compactMap { Int($0) }
    }
}

// MARK: - Models

struct Release: Codable {
    let tagName: String
    let draft: Bool
    let prerelease: Bool
    let publishedAt: String
    let assets: [Asset]

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case draft, prerelease
        case publishedAt = "published_at"
        case assets
    }
}

struct Asset: Codable {
    let name: String
    let size: Int
    let downloadCount: Int
    let browserDownloadURL: String

    enum CodingKeys: String, CodingKey {
        case name, size
        case downloadCount = "download_count"
        case browserDownloadURL = "browser_download_url"
    }
}

enum UpdateError: LocalizedError {
    case invalidURL
    case serverError
    case noRelease

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "無効な URL"
        case .serverError: return "サーバーエラー"
        case .noRelease: return "リリースが見つかりません"
        }
    }
}
