import SwiftUI

@MainActor
final class ScheduleViewModel: ObservableObject {

    @Published var bedtime: Date {
        didSet { updateSleepDuration() }
    }
    @Published var wakeUpTime: Date {
        didSet { updateSleepDuration() }
    }
    @Published var isHardLock: Bool
    @Published var selectedWeekdays: [Int]
    @Published var isEnabled: Bool
    @Published var sleepDurationText: String = "8h 0m"

    @Published var enableWindDownReminder: Bool
    @Published var windDownMinutes: Int
    @Published var enableWakeUpNotification: Bool

    private let scheduleManager = ScheduleManager.shared

    let weekdayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    init() {
        let calendar = Calendar.current

        var bedComponents = DateComponents()
        bedComponents.hour = scheduleManager.bedtimeHour
        bedComponents.minute = scheduleManager.bedtimeMinute
        self.bedtime = calendar.date(from: bedComponents) ?? Date()

        var wakeComponents = DateComponents()
        wakeComponents.hour = scheduleManager.wakeUpHour
        wakeComponents.minute = scheduleManager.wakeUpMinute
        self.wakeUpTime = calendar.date(from: wakeComponents) ?? Date().addingTimeInterval(28800)

        self.isHardLock = scheduleManager.isHardLock
        self.selectedWeekdays = scheduleManager.weekdays
        self.isEnabled = scheduleManager.isEnabled

        let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)
        self.enableWindDownReminder = defaults?.bool(forKey: AppGroupKeys.windDownReminderEnabled) ?? false
        var storedWindDown = defaults?.integer(forKey: AppGroupKeys.windDownMinutes) ?? 30
        if storedWindDown == 0 { storedWindDown = 30 }
        self.windDownMinutes = storedWindDown
        self.enableWakeUpNotification = defaults?.bool(forKey: AppGroupKeys.wakeUpNotificationEnabled) ?? true

        updateSleepDuration()
    }

    func saveSchedule() {
        let calendar = Calendar.current
        let bedComponents = calendar.dateComponents([.hour, .minute], from: bedtime)
        let wakeComponents = calendar.dateComponents([.hour, .minute], from: wakeUpTime)

        scheduleManager.bedtimeHour = bedComponents.hour ?? 22
        scheduleManager.bedtimeMinute = bedComponents.minute ?? 0
        scheduleManager.wakeUpHour = wakeComponents.hour ?? 6
        scheduleManager.wakeUpMinute = wakeComponents.minute ?? 0
        scheduleManager.isHardLock = isHardLock
        scheduleManager.weekdays = selectedWeekdays
        scheduleManager.isEnabled = isEnabled
        scheduleManager.saveSettings()

        let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)
        defaults?.set(enableWindDownReminder, forKey: AppGroupKeys.windDownReminderEnabled)
        defaults?.set(windDownMinutes, forKey: AppGroupKeys.windDownMinutes)
        defaults?.set(enableWakeUpNotification, forKey: AppGroupKeys.wakeUpNotificationEnabled)

        scheduleNotifications()
    }

    func toggleWeekday(_ day: Int) {
        withAnimation(.spring(duration: 0.3)) {
            if selectedWeekdays.contains(day) {
                selectedWeekdays.removeAll { $0 == day }
            } else {
                selectedWeekdays.append(day)
                selectedWeekdays.sort()
            }
        }
    }

    private func updateSleepDuration() {
        var duration = wakeUpTime.timeIntervalSince(bedtime)
        if duration < 0 { duration += 24 * 3600 }
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        sleepDurationText = "\(hours)h \(minutes)m"
    }

    private func scheduleNotifications() {
        let calendar = Calendar.current
        let bedComponents = calendar.dateComponents([.hour, .minute], from: bedtime)
        let wakeComponents = calendar.dateComponents([.hour, .minute], from: wakeUpTime)

        if enableWindDownReminder {
            let reminderHour = bedComponents.hour ?? 22
            let reminderMinute = bedComponents.minute ?? 0
            let adjustedMinute = max(0, reminderMinute - (windDownMinutes % 60))
            let adjustedHour = (reminderHour - windDownMinutes / 60 + 24) % 24
            NotificationManager.shared.scheduleBedtimeNotification(at: adjustedHour, minute: adjustedMinute)
        }

        if enableWakeUpNotification {
            NotificationManager.shared.scheduleWakeUpNotification(
                at: wakeComponents.hour ?? 6,
                minute: wakeComponents.minute ?? 0
            )
        }
    }
}
