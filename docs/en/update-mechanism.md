# OTA Update Mechanism

[Japanese](../update-mechanism.md)

Nezu App includes an OTA (Over-The-Air) update system powered by GitHub Releases.

## 📡 VersionManager

The `VersionManager` class (`test-app/nezu-app/VersionManager.swift`) is the core of the update system.

### Flow

```
1. Fetch releases from GitHub API
   GET https://api.github.com/repos/nezumi0627/nezu-app/releases

2. Filter out draft releases, keep only those with .ipa assets

3. Parse version from tag name
   - v{MAJOR}.{MINOR}.{PATCH}-build{N} → extract version string
   - build-{BUILD_NUMBER}-{HASH} → extract build number

4. Compare with local CFBundleShortVersionString / CFBundleVersion

5. If remote is newer → show update notification
```

### Version comparison

Semantic versioning with 4-level comparison: `major.minor.patch.build`

```swift
// Comparison order: major → minor → patch → build number
```

## 📥 Download

When an update is found:

1. Identify the `.ipa` asset in the latest release
2. Store the `browser_download_url`
3. Display a "Download IPA" button in the UI
4. On iOS, open the URL via `UIApplication.shared.open(url)`

## 🌐 Web Download Page

`docs/download.html` also provides browser-based IPA downloads:

- Real-time fetching from GitHub API
- Full release list with version, date, file size, download count
- SHA256 hash for file verification
- Build environment and commit history in collapsible details

## 🔄 CI/CD Integration

Builds are triggered only when the `Info.plist` version changes (see [Build Process](./build-process.md)).

To release a new version:

1. Update `CFBundleShortVersionString` / `CFBundleVersion` in `Info.plist`
2. Push to `main` branch
3. → Version change detected → build runs → Draft Release created
4. Publish the Draft Release on GitHub
5. → App / web page shows the latest version
