import Foundation
import SwiftUI

@MainActor
final class SimulatedShutdown: ObservableObject {

    static let shared = SimulatedShutdown()

    @Published var isShutdownActive = false
    @Published var shutdownEndTime: Date?

    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

    func startShutdown(until endTime: Date) {
        isShutdownActive = true
        shutdownEndTime = endTime

        defaults?.set(true, forKey: AppGroupKeys.shutdownStarted)
        defaults?.set(endTime, forKey: AppGroupKeys.scheduledEndTime)
    }

    func endShutdown() {
        isShutdownActive = false
        shutdownEndTime = nil

        defaults?.set(false, forKey: AppGroupKeys.shutdownStarted)
        defaults?.removeObject(forKey: AppGroupKeys.scheduledEndTime)
    }

    func checkAndEndIfExpired() {
        guard let endTime = shutdownEndTime ?? defaults?.object(forKey: AppGroupKeys.scheduledEndTime) as? Date else {
            return
        }
        if Date() >= endTime {
            endShutdown()
        }
    }

    var remainingTime: String {
        guard let endTime = shutdownEndTime else { return "--:--" }
        let remaining = max(0, endTime.timeIntervalSince(Date()))
        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        return String(format: "%dh %02dm", hours, minutes)
    }
}
