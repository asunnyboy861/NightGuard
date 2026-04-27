import DeviceActivity
import Foundation

class DeviceActivityMonitorExtension: DeviceActivityMonitor {

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        let shieldManager = ShieldManager.shared
        let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

        let isHardLock = defaults?.bool(forKey: AppGroupKeys.isHardLock) ?? true

        if isHardLock {
            Task { @MainActor in
                shieldManager.applyFullShield()
            }
        } else if let data = defaults?.data(forKey: AppGroupKeys.activitySelection),
                  let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            Task { @MainActor in
                shieldManager.applyBedtimeShield(selection: selection)
            }
        }

        defaults?.set(true, forKey: AppGroupKeys.isShieldActive)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        let shieldManager = ShieldManager.shared
        let chainScheduler = ChainScheduler.shared

        let slotIndex = extractSlotIndex(from: activity)

        if let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName),
           defaults.bool(forKey: AppGroupKeys.chainActive) {
            chainScheduler.handleSlotEnded(slotIndex: slotIndex)
        } else {
            Task { @MainActor in
                shieldManager.removeBedtimeShield()
            }
            SimulatedShutdown.shared.endShutdown()
            AccountabilityService.shared.scheduleWakeUpNotification()
        }
    }

    override func eventDidReachThreshold(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName
    ) {
        super.eventDidReachThreshold(event, activity: activity)

        AccountabilityService.shared.notifyPartnerOfBypassAttempt(at: Date())
    }

    private func extractSlotIndex(from name: DeviceActivityName) -> Int {
        let nameString = String(describing: name)
        if nameString.hasPrefix("nightguard_slot_") {
            let indexString = nameString.replacingOccurrences(of: "nightguard_slot_", with: "")
            return Int(indexString) ?? 0
        }
        return 0
    }
}
