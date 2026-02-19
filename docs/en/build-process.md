# Build & Distribution Process

[Japanese](../build-process.md)

Nezu App uses GitHub Actions to automatically build unsigned IPAs and distribute them via GitHub Releases.

## 🔄 Build Triggers

Builds run **only when the version changes**.

| Trigger              | Condition                                                                           |
| -------------------- | ----------------------------------------------------------------------------------- |
| `push` (main/master) | Only when `CFBundleShortVersionString` or `CFBundleVersion` in `Info.plist` changes |
| `workflow_dispatch`  | Manual — always builds                                                              |

### How version detection works

1. A `check-version` job runs on `ubuntu-latest` (lightweight, fast)
2. Compares the current `Info.plist` version to the previous commit using `git show HEAD~1`
3. If unchanged → skip build, post summary notification
4. If changed → `build` job runs on `macos-latest`

### How to update the version

Edit `test-app/nezu-app/Info.plist`:

```xml
<key>CFBundleShortVersionString</key>
<string>2.1.0</string>      <!-- version number -->
<key>CFBundleVersion</key>
<string>2</string>           <!-- build number -->
```

## 🚀 Workflow Structure

Defined in `.github/workflows/build-unsigned-ipa.yml`.

### Job flow

```
check-version (ubuntu-latest)  ← fast, free tier
    ↓ should_build=true?
build (macos-latest)           ← runs only on version change
    ↓ should_build=false?
skip-notice (ubuntu-latest)    ← skip notification
```

### Build environment

| Item    | Value                           |
| ------- | ------------------------------- |
| Runner  | `macos-latest`                  |
| Xcode   | 26.1                            |
| Signing | `CODE_SIGNING_ALLOWED=NO`       |
| Cache   | DerivedData (Swift source hash) |

## 📦 IPA Creation

### Unsigned build

Since this project is intended for sideloading, unsigned IPAs are generated:

- `CODE_SIGNING_ALLOWED=NO`
- `CODE_SIGNING_REQUIRED=NO`
- `CODE_SIGN_IDENTITY=""`

### IPA naming convention

```
{AppName}-v{VERSION}-build{BUILD_NUM}-{SHORT_SHA}.ipa
```

Example: `nezu-app-v2.0.0-build1-831eddd.ipa`

### Package structure

```
nezu-app.ipa
└── Payload/
    └── nezu-app.app/
        ├── Info.plist
        ├── PkgInfo
        └── ... (compiled binaries and assets)
```

## 📤 Distribution

After building, the IPA is uploaded as a **Draft Release** on GitHub.

| Item         | Value                                                 |
| ------------ | ----------------------------------------------------- |
| Tag          | `v{VERSION}-build{BUILD_NUM}` (e.g., `v2.0.0-build1`) |
| Release name | `Nezu App v{VERSION} (Build {BUILD_NUM})`             |
| Status       | Draft (published manually by maintainer)              |

### Release includes

- Version / build number
- Commit hash / branch
- IPA file size / SHA256 hash
- Build environment (Xcode / Swift / iOS SDK)
- Latest 10 commits

## 🌐 Download Page

`docs/download.html` provides a web page that fetches release information from the GitHub API and allows direct IPA downloads.
