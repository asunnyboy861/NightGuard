import SwiftUI

@MainActor
final class ScheduleViewModel: ObservableObject {

    @Published var bedtimeHour: Int = 22
    @Published var bedtimeMinute: Int = 0
    @Published var wakeUpHour: Int = 6
    @Published var wakeUpMinute: Int = 0
    @Published var isHardLock: Bool = true
    @Published var selectedWeekdays: [Int] = [2, 3, 4, 5, 6]
    @Published var isEnabled: Bool = true

    private let scheduleManager = ScheduleManager.shared

    let weekdayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    init() {
        bedtimeHour = scheduleManager.bedtimeHour
        bedtimeMinute = scheduleManager.bedtimeMinute
        wakeUpHour = scheduleManager.wakeUpHour
        wakeUpMinute = scheduleManager.wakeUpMinute
        isHardLock = scheduleManager.isHardLock
        selectedWeekdays = scheduleManager.weekdays
        isEnabled = scheduleManager.isEnabled
    }

    func saveSchedule() {
        scheduleManager.bedtimeHour = bedtimeHour
        scheduleManager.bedtimeMinute = bedtimeMinute
        scheduleManager.wakeUpHour = wakeUpHour
        scheduleManager.wakeUpMinute = wakeUpMinute
        scheduleManager.isHardLock = isHardLock
        scheduleManager.weekdays = selectedWeekdays
        scheduleManager.isEnabled = isEnabled
        scheduleManager.saveSettings()
    }

    func toggleWeekday(_ day: Int) {
        if selectedWeekdays.contains(day) {
            selectedWeekdays.removeAll { $0 == day }
        } else {
            selectedWeekdays.append(day)
            selectedWeekdays.sort()
        }
    }

    var sleepDurationText: String {
        let calendar = Calendar.current
        var bedComponents = DateComponents()
        bedComponents.hour = bedtimeHour
        bedComponents.minute = bedtimeMinute
        var wakeComponents = DateComponents()
        wakeComponents.hour = wakeUpHour
        wakeComponents.minute = wakeUpMinute

        guard let bedTime = calendar.date(from: bedComponents),
              let wakeTime = calendar.date(from: wakeComponents) else {
            return "8h 0m"
        }

        var duration = wakeTime.timeIntervalSince(bedTime)
        if duration < 0 { duration += 24 * 3600 }
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
