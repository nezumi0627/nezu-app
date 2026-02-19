# Nezu App Documentation

[Japanese](../README.md)

Welcome to the official documentation for Nezu App. Here you will find comprehensive guides on the build system, update mechanism, and design standards.

## 📖 Contents

### [Build & Distribution](./build-process.md)

How IPA files are automatically built with GitHub Actions and distributed via GitHub Releases.

- **Version-based triggers** — builds only run when `Info.plist` version changes
- **Unsigned IPA** — designed for sideloading via SideStore
- **Automatic releases** — IPA uploaded as a Draft Release

### [OTA Update System](./update-mechanism.md)

In-app update checking and IPA download mechanism.

- **VersionManager** — fetches and compares versions from GitHub API
- **Web download page** — `docs/download.html` for browser-based downloads

### [Design Philosophy](./design-guide.md)

**iOS 26 Liquid Glass** design system and UI/UX specifications.

---

## 🚀 Quick Start

1. Update the version in `test-app/nezu-app/Info.plist`
2. Push to the `main` branch
3. GitHub Actions detects the version change and builds automatically
4. Publish the Draft Release from the **Releases** tab
5. Install the IPA via SideStore

```
*Note: If 'swift' is not recognized, install the Swift toolchain from [swift.org](https://www.swift.org/install/windows/).*
```
