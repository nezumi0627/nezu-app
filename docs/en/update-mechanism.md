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

## 📥 Installer Integration

When an update is found, you can trigger a direct installation without manually downloading via a browser.

### SideStore / AltStore Integration

`VersionManager` checks if **SideStore** or **AltStore** is installed on the device and delivers the IPA URL directly via URL Schemes.

1. Locate the `.ipa` asset from the latest release.
2. Percent-encode the `browser_download_url`.
3. If an installer is found, open the following URL Scheme:
   - `sidestore://install?url={ENCODED_URL}`
   - `altstore://install?url={ENCODED_URL}`
4. Only if no compatible installer is found, it falls back to downloading the IPA via the system browser.

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
