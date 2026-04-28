# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- FamilyControls (Screen Time API) — core feature for app blocking
- ManagedSettings — shield application and removal
- ManagedSettingsUI — shield appearance customization
- DeviceActivity — scheduled monitoring events
- App Groups — cross-extension data sharing
- Siri / AppIntents — voice control shortcuts
- User Notifications — local and remote notifications
- In-App Purchase — subscription monetization
- Background Modes — background processing for scheduling

## Configured Capabilities

### Main App (com.zzoutuo.NightGuard)
| Capability | Status | Configuration |
|------------|--------|---------------|
| FamilyControls | Configured | Entitlement: `com.apple.developer.family-controls = true` |
| App Groups | Configured | Group: `group.com.zzoutuo.NightGuard.shared` |
| Siri | Configured | Entitlement: `com.apple.developer.siri = true` |
| Push Notifications | Configured | Entitlement: `aps-environment = development` |
| In-App Purchase | Configured | StoreKit 2 framework linked |
| Background Modes | Configured | Framework: UserNotifications |
| ManagedSettings | Configured | Framework linked |
| ManagedSettingsUI | Configured | Framework linked |
| DeviceActivity | Configured | Framework linked |
| AppIntents | Configured | Framework linked |
| SwiftData | Configured | Framework linked |
| MessageUI | Configured | Framework linked |

### ShieldActionExtension (com.zzoutuo.NightGuard.ShieldActionExtension)
| Capability | Status | Configuration |
|------------|--------|---------------|
| FamilyControls | Configured | Entitlement: `com.apple.developer.family-controls = true` |
| App Groups | Configured | Group: `group.com.zzoutuo.NightGuard.shared` |
| ManagedSettings | Configured | Framework linked, inherits `ShieldActionDelegate` |

### ShieldConfigurationExtension (com.zzoutuo.NightGuard.ShieldConfigurationExtension)
| Capability | Status | Configuration |
|------------|--------|---------------|
| FamilyControls | Configured | Entitlement: `com.apple.developer.family-controls = true` |
| App Groups | Configured | Group: `group.com.zzoutuo.NightGuard.shared` |
| ManagedSettings | Configured | Framework linked |
| ManagedSettingsUI | Configured | Framework linked, inherits `ShieldConfigurationDataSource` |

### DeviceActivityMonitorExtension (com.zzoutuo.NightGuard.DeviceActivityMonitorExtension)
| Capability | Status | Configuration |
|------------|--------|---------------|
| FamilyControls | Configured | Entitlement: `com.apple.developer.family-controls = true` |
| App Groups | Configured | Group: `group.com.zzoutuo.NightGuard.shared` |
| ManagedSettings | Configured | Framework linked, uses `ManagedSettingsStore` |
| DeviceActivity | Configured | Framework linked, inherits `DeviceActivityMonitor` |

## Entitlements Files

### NightGuard/NightGuard/NightGuard.entitlements
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.family-controls</key>
    <true/>
    <key>com.apple.developer.siri</key>
    <true/>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.zzoutuo.NightGuard.shared</string>
    </array>
    <key>aps-environment</key>
    <string>development</string>
</dict>
</plist>
```

### Extension Entitlements (all 3 extensions share same structure)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.family-controls</key>
    <true/>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.zzoutuo.NightGuard.shared</string>
    </array>
</dict>
</plist>
```

## Extension Architecture

### ShieldActionExtension
- Base class: `ManagedSettings.ShieldActionDelegate`
- Purpose: Handle user taps on shield buttons (primary/secondary)
- Communication: Writes override requests to shared UserDefaults
- Key methods:
  - `handle(action:for application:completionHandler:)` — app shield button
  - `handle(action:for webDomain:completionHandler:)` — web domain shield button
  - `handle(action:for category:completionHandler:)` — category shield button

### ShieldConfigurationExtension
- Base class: `ManagedSettingsUI.ShieldConfigurationDataSource`
- Purpose: Customize shield UI appearance (dark theme, NightGuard branding)
- Communication: Read-only, no shared state needed
- Key methods:
  - `configuration(shielding application:)` — app shield appearance
  - `configuration(shielding application:in category:)` — app+category shield
  - `configuration(shielding webDomain:)` — web domain shield appearance
  - `configuration(shielding webDomain:in category:)` — web+category shield

### DeviceActivityMonitorExtension
- Base class: `DeviceActivity.DeviceActivityMonitor`
- Purpose: Respond to schedule start/end events, apply/remove shields
- Communication: Reads settings from shared UserDefaults, writes status updates
- Key methods:
  - `intervalDidStart(for:)` — apply shield when schedule starts
  - `intervalDidEnd(for:)` — remove shield when schedule ends
  - `eventDidReachThreshold(_:activity:)` — detect bypass attempts

## Shared Data Keys (App Group UserDefaults)
| Key | Type | Written By | Read By |
|-----|------|-----------|---------|
| `isHardLock` | Bool | Main App | DeviceActivityMonitorExtension |
| `activitySelection` | Data (encoded FamilyActivitySelection) | Main App | DeviceActivityMonitorExtension |
| `isShieldActive` | Bool | DeviceActivityMonitorExtension | Main App |
| `scheduleEnded` | Bool | DeviceActivityMonitorExtension | Main App |
| `chainActive` | Bool | Main App | DeviceActivityMonitorExtension |
| `emergency_override_requested` | Bool | ShieldActionExtension | Main App |
| `emergency_override_time` | Date | ShieldActionExtension | Main App |
| `bypassAttemptDetected` | Bool | DeviceActivityMonitorExtension | Main App |
| `bypassAttemptTime` | Date | DeviceActivityMonitorExtension | Main App |

## Manual Configuration Required (Apple Developer Portal)
| Step | Action | Details |
|------|--------|---------|
| 1 | Register App IDs | Register `com.zzoutuo.NightGuard` and all 3 extension bundle IDs |
| 2 | Enable Family Controls | In Apple Developer Portal > Identifiers > App Services > enable Family Controls for all 4 bundle IDs |
| 3 | Create App Group | Create `group.com.zzoutuo.NightGuard.shared` and assign to all 4 bundle IDs |
| 4 | Enable Push Notifications | Enable for main app bundle ID |
| 5 | Enable Siri | Enable for main app bundle ID |
| 6 | Regenerate Profiles | After enabling services, regenerate all provisioning profiles |
| 7 | In-App Purchase | Configure subscription products in App Store Connect |

## Project Generation
Project is generated using xcodegen from `project.yml`:
```bash
cd /Volumes/ORICO-APFS/app/20260423/20260427/NightGuard
xcodegen generate
```

## Verification
- Build succeeded after configuration: YES
- All entitlements correct: YES
- Extension targets compile: YES
- Framework dependencies resolved: YES
