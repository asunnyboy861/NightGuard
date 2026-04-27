import Foundation
import FamilyControls
import ManagedSettings

@MainActor
final class ScheduleManager: ObservableObject {

    static let shared = ScheduleManager()

    @Published var bedtimeHour: Int = 22
    @Published var bedtimeMinute: Int = 0
    @Published var wakeUpHour: Int = 6
    @Published var wakeUpMinute: Int = 0
    @Published var isHardLock: Bool = true
    @Published var weekdays: [Int] = [2, 3, 4, 5, 6]
    @Published var isEnabled: Bool = true

    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

    init() {
        loadSettings()
    }

    func loadSettings() {
        bedtimeHour = defaults?.integer(forKey: AppGroupKeys.bedtimeHour) ?? 22
        bedtimeMinute = defaults?.integer(forKey: AppGroupKeys.bedtimeMinute) ?? 0
        wakeUpHour = defaults?.integer(forKey: AppGroupKeys.wakeUpHour) ?? 6
        wakeUpMinute = defaults?.integer(forKey: AppGroupKeys.wakeUpMinute) ?? 0
        isHardLock = defaults?.bool(forKey: AppGroupKeys.isHardLock) ?? true
        weekdays = defaults?.array(forKey: AppGroupKeys.selectedWeekdays) as? [Int] ?? [2, 3, 4, 5, 6]
        isEnabled = defaults?.bool(forKey: AppGroupKeys.scheduleEnabled) ?? true
    }

    func saveSettings() {
        defaults?.set(bedtimeHour, forKey: AppGroupKeys.bedtimeHour)
        defaults?.set(bedtimeMinute, forKey: AppGroupKeys.bedtimeMinute)
        defaults?.set(wakeUpHour, forKey: AppGroupKeys.wakeUpHour)
        defaults?.set(wakeUpMinute, forKey: AppGroupKeys.wakeUpMinute)
        defaults?.set(isHardLock, forKey: AppGroupKeys.isHardLock)
        defaults?.set(weekdays, forKey: AppGroupKeys.selectedWeekdays)
        defaults?.set(isEnabled, forKey: AppGroupKeys.scheduleEnabled)
    }

    func activateBedtimeNow() {
        let shieldManager = ShieldManager.shared

        if let selectionData = defaults?.data(forKey: AppGroupKeys.activitySelection),
           let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: selectionData) {
            if isHardLock {
                shieldManager.applyFullShield()
            } else {
                shieldManager.applyBedtimeShield(selection: selection)
            }
        }

        let wakeTime = calculateNextWakeTime()
        ChainScheduler.shared.startChainMonitoring(from: Date(), until: wakeTime)
        SimulatedShutdown.shared.startShutdown(until: wakeTime)
    }

    func deactivateBedtime() {
        ShieldManager.shared.removeBedtimeShield()
        ChainScheduler.shared.stopChainMonitoring()
        SimulatedShutdown.shared.endShutdown()
    }

    private func calculateNextWakeTime() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = wakeUpHour
        components.minute = wakeUpMinute

        guard let wakeTime = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime) else {
            return Date().addingTimeInterval(8 * 3600)
        }
        return wakeTime
    }
}
