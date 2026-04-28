# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | NightGuard |
| **Git URL** | git@github.com:asunnyboy861/NightGuard.git |
| **Repo URL** | https://github.com/asunnyboy861/NightGuard |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/NightGuard/ | ✅ Active |
| Support | https://asunnyboy861.github.io/NightGuard/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/NightGuard/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/NightGuard/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

```
NightGuard/
├── NightGuard/                   # iOS App Source Code
│   ├── NightGuard.xcodeproj/     # Xcode Project
│   ├── NightGuard/               # Swift Source Files
│   │   ├── Views/                # UI Views (SwiftUI)
│   │   ├── ViewModels/           # MVVM ViewModels
│   │   ├── Models/               # Data Models
│   │   ├── Services/             # Business Logic Services
│   │   ├── Intents/              # App Intents (Shortcuts)
│   │   └── Shared/               # Shared Constants
│   ├── Extensions/               # App Extensions
│   │   ├── ShieldConfigurationExtension/
│   │   ├── ShieldActionExtension/
│   │   └── DeviceActivityMonitorExtension/
│   ├── NightGuardTests/          # Unit Tests
│   └── NightGuardUITests/        # UI Tests
├── docs/                         # Policy Pages (for GitHub Pages)
│   ├── support.html             # Support Page
│   ├── privacy.html             # Privacy Policy
│   └── terms.html               # Terms of Use
├── us.md                         # English Development Guide
├── keytext.md                    # App Store Metadata
├── capabilities.md               # Capabilities Configuration
├── icon.md                       # App Icon Details
├── price.md                      # Pricing Configuration
└── nowgit.md                     # This File
```

## Recent Changes

### 2026-04-28
- ✅ Fixed simulator compatibility by conditionally embedding Screen Time API extensions
- ✅ Fixed Onboarding "Get Started" button not responding (UserDefaults sync issue)
- ✅ Created GitHub repository and pushed initial code
- ✅ Deployed policy pages to GitHub Pages
- ✅ Updated SettingsView with correct policy page URLs

## Build Requirements

- **Xcode**: 16.0+
- **iOS Deployment Target**: 17.0+
- **Swift Version**: 5.9+
- **Screen Time API**: Required for full functionality (physical device only)

## Notes

- Screen Time API extensions (ShieldConfiguration, ShieldAction, DeviceActivityMonitor) are only supported on physical devices
- Simulator builds skip embedding these extensions to allow testing UI/UX
- Full functionality requires testing on a real iOS device with Screen Time permissions
- Policy pages are served from GitHub Pages at `https://asunnyboy861.github.io/NightGuard/`
