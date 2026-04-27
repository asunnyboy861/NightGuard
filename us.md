# NightGuard - iOS Development Guide

## Executive Summary

NightGuard is the world's first truly "force lock screen + scheduled on/off + AI sleep guardian" iOS app, solving the severe health problem of late-night phone scrolling leading to sleep deprivation. Targeting the US market where 60%+ adults use phones in bed and 57% admit phone addiction, NightGuard leverages Apple's Screen Time API (FamilyControls + ManagedSettings + DeviceActivity) to deliver an unbypassable shield system.

**Product Vision**: Transform the relationship between Americans and their phones at night. NightGuard doesn't just remind — it enforces.

**Key Differentiators**:
- Triple Shield Architecture: Shield Extension + DeviceActivity Monitor + Main App — no single bypass point
- Simulated Shutdown: Black screen + full app lock = equivalent to phone being off
- Scheduled "Power On": Morning auto-unlock with progressive wake-up experience
- Accountability Partner: Real-time notification to partner on bypass attempts
- Siri Voice Control: "Hey Siri, start NightGuard" deep integration
- Chain Scheduling: Solves the 45-minute DeviceActivity scheduling limitation

**Target Audience**: US adults 18-45 who struggle with late-night phone use, especially social media and streaming addiction.

## Competitive Analysis

| App | Price | Blocking Method | Bypassable? | Siri | Scheduled On/Off | Accountability |
|-----|-------|-----------------|-------------|------|-------------------|----------------|
| **NightGuard** | Free+$3.99/mo | Screen Time API Triple Shield | Extremely Hard | Deep | Yes (Innovation) | Yes (Partner) |
| Opal | $8.33/mo-$99/yr | Screen Time API | Bypassable | No | No | No |
| One Sec | $1.99/mo-$99 lifetime | Breathing Delay | Skippable | No | No | No |
| Freedom | $6.67/mo | VPN Blocking | Bypassable | No | No | No |
| iOS Screen Time | Free | Built-in Limits | One-tap bypass | No | No | No |

**Our Advantage**: NightGuard is the ONLY app that combines unbypassable shielding with scheduled on/off simulation, Siri control, and accountability partner features. Opal charges $99/yr; we charge $29.99/yr with more features.

## Apple Design Guidelines Compliance

- **FamilyControls**: Requires explicit user authorization via Face ID/Touch ID. We follow the authorization flow precisely.
- **ManagedSettings**: Shield UI must use ShieldConfigurationExtension for custom appearance. We implement both ShieldActionExtension and ShieldConfigurationExtension.
- **DeviceActivity**: Monitoring extensions must be lightweight. We use chain scheduling to handle long monitoring periods.
- **AppIntents**: Siri Shortcuts follow Apple's AppShortcutsProvider pattern with natural language phrases.
- **Privacy**: All data stored locally via App Group UserDefaults. No data leaves the device. Privacy descriptions required for FamilyControls.
- **Health**: App deals with sleep wellness but does not provide medical advice. No HealthKit integration in v1.
- **App Store Review 2.5.6**: Screen Time API apps require clear explanation of purpose. We provide onboarding that explains why each permission is needed.

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (if needed for advanced shield UI)
- **Data**: SwiftData (main app) + App Group UserDefaults (cross-extension sharing)
- **Screen Time API**: FamilyControls + ManagedSettings + DeviceActivity
- **Siri**: AppIntents framework
- **Payments**: StoreKit 2
- **Notifications**: UserNotifications (local) + future APNs (remote)
- **Live Activity**: ActivityKit for lock screen black screen display

## Module Structure

```
NightGuard/
├── NightGuardApp.swift
├── Models/
│   ├── BedtimeSchedule.swift
│   ├── ShieldConfiguration.swift
│   ├── AccountabilityPartner.swift
│   └── MorningRoutine.swift
├── Views/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift
│   │   └── OnboardingPage.swift
│   ├── MainTabView.swift
│   ├── Shield/
│   │   ├── ShieldView.swift
│   │   └── ActiveShieldView.swift
│   ├── Schedule/
│   │   └── ScheduleSetupView.swift
│   ├── AppSelection/
│   │   └── AppSelectionView.swift
│   ├── Stats/
│   │   └── StatsView.swift
│   ├── Partner/
│   │   └── PartnerView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── ContactSupportView.swift
│   └── Paywall/
│       └── PaywallView.swift
├── ViewModels/
│   ├── ShieldViewModel.swift
│   ├── ScheduleViewModel.swift
│   ├── StatsViewModel.swift
│   └── OnboardingViewModel.swift
├── Services/
│   ├── ShieldManager.swift
│   ├── ScheduleManager.swift
│   ├── ChainScheduler.swift
│   ├── SimulatedShutdown.swift
│   ├── AccountabilityService.swift
│   ├── StoreManager.swift
│   └── NotificationManager.swift
├── Extensions/
│   ├── ShieldActionExtension/
│   │   └── ShieldActionExtension.swift
│   └── ShieldConfigurationExtension/
│       └── ShieldConfigurationExtension.swift
├── DeviceActivityMonitorExtension/
│   └── DeviceActivityMonitorExtension.swift
├── Intents/
│   ├── StartNightGuardIntent.swift
│   └── StopNightGuardIntent.swift
└── Shared/
    └── AppGroupConstants.swift
```

## Implementation Flow

1. Create Xcode project with FamilyControls entitlement + App Group
2. Add 3 Extension Targets: ShieldActionExtension, ShieldConfigurationExtension, DeviceActivityMonitorExtension
3. Implement FamilyControls authorization flow
4. Implement FamilyActivityPicker for app selection
5. Implement ManagedSettingsStore for shield application/removal
6. Implement Shield Extensions (custom black screen UI + bypass prevention)
7. Implement ChainScheduler for reliable long-duration DeviceActivity monitoring
8. Implement ScheduleManager for bedtime/wake-up time scheduling
9. Implement SimulatedShutdown for black screen + full lock experience
10. Implement AppIntents for Siri Shortcuts
11. Implement AccountabilityService for partner notifications
12. Implement StatsView with sleep tracking and bypass attempt logs
13. Implement StoreManager with StoreKit 2 for subscriptions
14. Implement Onboarding flow
15. Implement Contact Support
16. UI polish + Dark Mode optimization

## UI/UX Design Specifications

- **Color Scheme**: Deep Indigo (#1A1A2E) primary, Soft Purple (#6C63FF) accent, Moonlight Silver (#E8E8E8), Warm Orange (#FF6B35) for morning/motivation
- **Typography**: SF Pro (system default) — no custom fonts needed
- **Icons**: SF Symbols 5 — consistent with iOS design language
- **Corner Radius**: 16pt (cards), 12pt (buttons), 24pt (modals)
- **Spacing**: 8pt grid system (8, 16, 24, 32, 48)
- **Dark Mode**: Primary design target — deep indigo background, soft purple accents
- **Tab Navigation**: 4 tabs — Shield, Stats, Partner, Settings
- **Layout**: For main content in ScrollView, add `.frame(maxWidth: 720).frame(maxWidth: .infinity)` for iPad compatibility

## Code Generation Rules

- No comments in code unless explicitly requested
- App Group UserDefaults for all cross-extension data sharing
- Synchronous check first when app returns to foreground before async operations
- Triple-dimension shield: always set applications + applicationCategories + webDomains together
- Never trust boolean flags alone — always verify with timestamp
- DeviceActivity single schedule max 44 minutes — use chain scheduling for longer periods
- Guard intervalDidEnd — don't assume it means "time's up", check actual state first
- All core features provide Siri voice phrases for discoverability
- MVVM pattern: View + ViewModel per module
- Single responsibility: one feature per module, high cohesion, low coupling

## Build & Deployment Checklist

- [ ] FamilyControls entitlement configured in Apple Developer Portal
- [ ] App Group configured (group.com.zzoutuo.NightGuard.shared)
- [ ] 3 Extension Targets added and configured
- [ ] Info.plist privacy descriptions added
- [ ] Bundle ID: com.zzoutuo.NightGuard
- [ ] Deployment Target: iOS 17.0
- [ ] StoreKit Configuration file for testing IAP
- [ ] Test on iPhone XS Max simulator
- [ ] Test on iPad Pro 13-inch (M4) simulator
- [ ] Push to GitHub repository
- [ ] Policy pages deployed to GitHub Pages
