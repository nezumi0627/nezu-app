# Build & Distribution Process

[Japanese](../build-process.md)

Nezu App uses a fully automated CI/CD pipeline to ensure that every code change is verified and packaged for distribution.

## 🚀 GitHub Actions Workflow
The build is defined in `.github/workflows/build-unsigned-ipa.yml`.

### 1. Build Environment
- **Platform**: `macos-latest` (Apple's latest Xcode environment)
- **Tooling**: `xcodebuild`, `zip`, `git`

### 2. Unsigned IPA Creation
Since this project is intended for sideloading, we generate **unsigned** IPAs.
- `CODE_SIGNING_ALLOWED=NO`
- `CODE_SIGNING_REQUIRED=NO`

### 3. Packaging Structure
The IPA is created by packaging the `.app` bundle into a `Payload` directory:
```text
nezu-app.ipa
└── Payload/
    └── nezu-app.app/
        ├── Info.plist
        ├── PkgInfo
        └── ... (Compiled binaries and assets)
```

## 📦 Distribution
Once built, the IPA is uploaded as a **Draft Release** on GitHub.
- **Tag Naming**: `build-{RUN_NUMBER}-{SHA}`
- **Security**: Draft releases allow maintainers to verify the build before making it public.
