# OTA Update Mechanism

[Japanese](../update-mechanism.md)

Nezu App features a custom Over-The-Air (OTA) update system that eliminates the need for manual checks.

## 📡 VersionManager Logic
The `VersionManager` class is the heart of the update system.

### Information Retrieval
It pulls release data from the GitHub API:
`GET https://api.github.com/repos/nezumi0627/nezu-app/releases`

### Version Parsing
We use a tag-based versioning system:
- **Format**: `build-{BUILD_NUMBER}-{COMMIT_HASH}`
- **Logic**: The manager extracts the `{BUILD_NUMBER}` and compares it with the local `CFBundleVersion`.

### Download Strategy
When an update is found:
1. The app identifies the `.ipa` asset in the latest release.
2. It stores the `browser_download_url`.
3. The UI presents a "Download IPA" button which opens the URL in the system browser.

## 💻 Cross-Platform Compatibility
The `VersionManager` is written to be platform-agnostic where possible:
- **iOS**: Uses `UIApplication` to open download links.
- **Other (Windows/CLI)**: Prints the URL for debugging purposes.
