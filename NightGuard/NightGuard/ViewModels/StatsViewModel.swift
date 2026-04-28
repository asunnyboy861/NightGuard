import SwiftUI
import SwiftData

@MainActor
final class StatsViewModel: ObservableObject {

    @Published var recentRecords: [SleepRecord] = []
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var totalBypassAttempts: Int = 0
    @Published var averageSleepHours: Double = 0
    @Published var isHealthKitConnected = false

    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)
    let healthKitService = HealthKitService.shared

    func loadStats(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<SleepRecord>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        do {
            recentRecords = try modelContext.fetch(descriptor)
        } catch {
            recentRecords = []
        }

        totalBypassAttempts = defaults?.integer(forKey: AppGroupKeys.bypassAttempts) ?? 0

        if !recentRecords.isEmpty {
            let totalDuration = recentRecords.reduce(0.0) { $0 + $1.durationSeconds }
            averageSleepHours = totalDuration / Double(recentRecords.count) / 3600.0
        }

        loadStreaks(modelContext: modelContext)
        isHealthKitConnected = healthKitService.isAuthorized
    }

    func requestHealthKitAccess() async {
        do {
            let granted = try await healthKitService.requestAuthorization()
            isHealthKitConnected = granted
        } catch {
            isHealthKitConnected = false
        }
    }

    func syncUnsyncedRecords(modelContext: ModelContext) async {
        let unsynced = recentRecords.filter { !$0.isSyncedToHealthKit }
        for record in unsynced {
            do {
                try await healthKitService.saveSleepAnalysis(startDate: record.bedtime, endDate: record.wakeTime)
                record.isSyncedToHealthKit = true
            } catch {
                continue
            }
        }
    }

    private func loadStreaks(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<MorningStreak>(sortBy: [SortDescriptor(\.currentDate, order: .reverse)])
        do {
            let streaks = try modelContext.fetch(descriptor)
            if let latest = streaks.first {
                currentStreak = latest.streakCount
                longestStreak = latest.longestStreak
            }
        } catch {
            currentStreak = 0
            longestStreak = 0
        }
    }

    var formattedAverageSleep: String {
        String(format: "%.1f", averageSleepHours)
    }
}
