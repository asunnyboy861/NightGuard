import AppIntents
import FamilyControls

struct StartNightGuardIntent: AppIntent {

    static var title: LocalizedStringResource = "Start NightGuard"
    static var description = IntentDescription("Activate NightGuard bedtime protection immediately.")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        let shieldManager = ShieldManager.shared
        let scheduleManager = ScheduleManager.shared
        scheduleManager.loadSettings()

        if let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName),
           let data = defaults.data(forKey: AppGroupKeys.activitySelection),
           let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            if scheduleManager.isHardLock {
                shieldManager.applyFullShield()
            } else {
                shieldManager.applyBedtimeShield(selection: selection)
            }
        }

        let wakeTime = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: scheduleManager.wakeUpHour, minute: scheduleManager.wakeUpMinute),
            matchingPolicy: .nextTime
        ) ?? Date().addingTimeInterval(8 * 3600)

        ChainScheduler.shared.startChainMonitoring(from: Date(), until: wakeTime)
        SimulatedShutdown.shared.startShutdown(until: wakeTime)

        return .result(dialog: "NightGuard is now active. Sleep well!")
    }
}
