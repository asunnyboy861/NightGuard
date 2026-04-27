import Foundation
import SwiftData

@Model
final class BedtimeSchedule {
    var id: UUID
    var bedtimeHour: Int
    var bedtimeMinute: Int
    var wakeUpHour: Int
    var wakeUpMinute: Int
    var isEnabled: Bool
    var isHardLock: Bool
    var weekdays: [Int]
    var createdAt: Date
    var updatedAt: Date

    var durationInSeconds: TimeInterval {
        let calendar = Calendar.current
        var bedComponents = DateComponents()
        bedComponents.hour = bedtimeHour
        bedComponents.minute = bedtimeMinute
        var wakeComponents = DateComponents()
        wakeComponents.hour = wakeUpHour
        wakeComponents.minute = wakeUpMinute

        guard let bedTime = calendar.date(from: bedComponents),
              let wakeTime = calendar.date(from: wakeComponents) else {
            return 8 * 3600
        }

        var duration = wakeTime.timeIntervalSince(bedTime)
        if duration < 0 { duration += 24 * 3600 }
        return duration
    }

    init(bedtimeHour: Int = 22, bedtimeMinute: Int = 0,
         wakeUpHour: Int = 6, wakeUpMinute: Int = 0,
         isEnabled: Bool = true, isHardLock: Bool = true,
         weekdays: [Int] = [2, 3, 4, 5, 6]) {
        self.id = UUID()
        self.bedtimeHour = bedtimeHour
        self.bedtimeMinute = bedtimeMinute
        self.wakeUpHour = wakeUpHour
        self.wakeUpMinute = wakeUpMinute
        self.isEnabled = isEnabled
        self.isHardLock = isHardLock
        self.weekdays = weekdays
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
