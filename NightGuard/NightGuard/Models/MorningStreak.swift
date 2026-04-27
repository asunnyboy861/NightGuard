import Foundation
import SwiftData

@Model
final class MorningStreak {
    var id: UUID
    var currentDate: Date
    var streakCount: Int
    var longestStreak: Int

    init(currentDate: Date = Date(), streakCount: Int = 0, longestStreak: Int = 0) {
        self.id = UUID()
        self.currentDate = currentDate
        self.streakCount = streakCount
        self.longestStreak = longestStreak
    }
}
