import Foundation
import SwiftData

@Model
final class SleepRecord {
    var id: UUID
    var date: Date
    var bedtime: Date
    var wakeTime: Date
    var durationSeconds: Double
    var bypassAttemptCount: Int
    var wasHardLock: Bool
    var isSyncedToHealthKit: Bool
    var sleepQuality: Int?

    init(date: Date, bedtime: Date, wakeTime: Date, durationSeconds: Double, bypassAttemptCount: Int = 0, wasHardLock: Bool = true, sleepQuality: Int? = nil) {
        self.id = UUID()
        self.date = date
        self.bedtime = bedtime
        self.wakeTime = wakeTime
        self.durationSeconds = durationSeconds
        self.bypassAttemptCount = bypassAttemptCount
        self.wasHardLock = wasHardLock
        self.isSyncedToHealthKit = false
        self.sleepQuality = sleepQuality
    }
}
