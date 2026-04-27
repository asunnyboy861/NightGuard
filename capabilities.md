# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- FamilyControls (Screen Time API) — core feature for app blocking
- ManagedSettings — shield application and removal
- DeviceActivity — scheduled monitoring events
- App Groups — cross-extension data sharing
- Siri / AppIntents — voice control shortcuts
- User Notifications — local and remote notifications
- In-App Purchase — subscription monetization
- Background Modes — background processing for scheduling

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| App Groups | Pending | Xcode project configuration |
| Siri | Pending | Xcode project configuration |
| Push Notifications | Pending | Xcode project configuration |
| In-App Purchase | Pending | Xcode project configuration |
| Background Modes | Pending | Xcode project configuration |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| FamilyControls Entitlement | Pending | 1. Go to Apple Developer Portal > Certificates, Identifiers & Profiles > Identifiers > com.zzoutuo.NightGuard > App Services > enable Family Controls 2. Regenerate provisioning profile 3. Add FamilyControls framework to project |
| App Group Configuration | Pending | 1. In Xcode > Signing & Capabilities > App Groups > add "group.com.zzoutuo.NightGuard.shared" 2. Add same group to all extension targets |

## Extension Targets Required
| Extension | Purpose | Status |
|-----------|---------|--------|
| ShieldActionExtension | Handle user interaction with shield UI | Pending |
| ShieldConfigurationExtension | Customize shield appearance (black screen) | Pending |
| DeviceActivityMonitorExtension | Monitor device activity events, chain scheduling | Pending |

## No Configuration Needed
- HealthKit — not used in v1
- Camera/Photo Library — not needed
- Location Services — not needed
- iCloud/CloudKit — local storage only
- Apple Watch — not in v1

## Verification
- Build succeeded after configuration: Pending
- All entitlements correct: Pending
