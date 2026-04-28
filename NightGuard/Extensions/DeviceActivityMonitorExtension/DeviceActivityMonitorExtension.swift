import DeviceActivity
import FamilyControls
import ManagedSettings
import Foundation

class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        let defaults = UserDefaults(suiteName: "group.com.zzoutuo.NightGuard.shared")
        let isHardLock = defaults?.bool(forKey: "isHardLock") ?? true
        let store = ManagedSettingsStore()

        if isHardLock {
            store.shield.applicationCategories = .all()
        } else if let data = defaults?.data(forKey: "activitySelection"),
                  let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            store.shield.applications = selection.applicationTokens
            store.shield.webDomains = selection.webDomainTokens
            if !selection.categoryTokens.isEmpty {
                store.shield.applicationCategories = .specific(selection.categoryTokens)
            }
        }

        defaults?.set(true, forKey: "isShieldActive")
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        let defaults = UserDefaults(suiteName: "group.com.zzoutuo.NightGuard.shared")
        let store = ManagedSettingsStore()
        store.clearAllSettings()

        let isChainActive = defaults?.bool(forKey: "chainActive") ?? false

        if !isChainActive {
            defaults?.set(false, forKey: "isShieldActive")
            defaults?.set(true, forKey: "scheduleEnded")
        }
    }

    override func eventDidReachThreshold(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName
    ) {
        super.eventDidReachThreshold(event, activity: activity)

        let defaults = UserDefaults(suiteName: "group.com.zzoutuo.NightGuard.shared")
        defaults?.set(true, forKey: "bypassAttemptDetected")
        defaults?.set(Date(), forKey: "bypassAttemptTime")
    }
}
