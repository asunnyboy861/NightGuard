import SwiftUI
import FamilyControls

@MainActor
final class ShieldViewModel: ObservableObject {

    @Published var isShieldActive = false
    @Published var isHardLock = true
    @Published var showActivityPicker = false
    @Published var selectedApps: FamilyActivitySelection?

    private let shieldManager = ShieldManager.shared
    private let scheduleManager = ScheduleManager.shared
    private let simulatedShutdown = SimulatedShutdown.shared

    let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

    init() {
        isShieldActive = defaults?.bool(forKey: AppGroupKeys.isShieldActive) ?? false
        isHardLock = defaults?.bool(forKey: AppGroupKeys.isHardLock) ?? true
        loadSelectedApps()
    }

    func requestAuthorization() async throws {
        try await shieldManager.requestAuthorization()
    }

    func startShieldNow() {
        guard let selection = selectedApps else { return }

        if isHardLock {
            shieldManager.applyFullShield()
        } else {
            shieldManager.applyBedtimeShield(selection: selection)
        }

        let wakeTime = calculateWakeTime()
        ChainScheduler.shared.startChainMonitoring(from: Date(), until: wakeTime)
        simulatedShutdown.startShutdown(until: wakeTime)

        isShieldActive = true
    }

    func stopShield() {
        shieldManager.removeBedtimeShield()
        ChainScheduler.shared.stopChainMonitoring()
        simulatedShutdown.endShutdown()
        isShieldActive = false
    }

    func emergencyOverride() {
        stopShield()
        AccountabilityService.shared.notifyPartnerOfEmergencyOverride()
    }

    private func loadSelectedApps() {
        guard let data = defaults?.data(forKey: AppGroupKeys.activitySelection),
              let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) else {
            return
        }
        selectedApps = selection
    }

    private func calculateWakeTime() -> Date {
        let wakeHour = scheduleManager.wakeUpHour
        let wakeMinute = scheduleManager.wakeUpMinute
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = wakeHour
        components.minute = wakeMinute

        guard let wakeTime = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime) else {
            return Date().addingTimeInterval(8 * 3600)
        }
        return wakeTime
    }
}
