import Foundation
import SwiftData
import UserNotifications

final class PartnerNotificationService: ObservableObject {

    static let shared = PartnerNotificationService()

    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

    enum NotificationType {
        case bypassAttempt(date: Date, appName: String?)
        case emergencyOverride(date: Date)
        case dailyReport(durationHours: Double, quality: Int?)
        case streakMilestone(days: Int)

        var title: String {
            switch self {
            case .bypassAttempt: return "NightGuard Alert"
            case .emergencyOverride: return "Emergency Override Used"
            case .dailyReport: return "Daily Sleep Report"
            case .streakMilestone(let days): return "\(days) Day Streak!"
            }
        }

        func message(for userName: String) -> String {
            switch self {
            case .bypassAttempt(let date, let appName):
                let app = appName ?? "a blocked app"
                return "\(userName) tried to open \(app) at \(date.formatted(date: .omitted, time: .shortened)). NightGuard blocked it!"
            case .emergencyOverride(let date):
                return "\(userName) used Emergency Override at \(date.formatted(date: .omitted, time: .shortened)). Check in on them?"
            case .dailyReport(let hours, let quality):
                let qualityText = quality.map { "\($0)/5" } ?? "N/A"
                return "\(userName) slept \(String(format: "%.1f", hours)) hours last night. Quality: \(qualityText)"
            case .streakMilestone(let days):
                return "\(userName) has maintained their sleep schedule for \(days) days in a row!"
            }
        }
    }

    func notifyPartners(type: NotificationType, from context: ModelContext) {
        let descriptor = FetchDescriptor<AccountabilityPartner>()
        guard let partners = try? context.fetch(descriptor) else { return }

        let userName = defaults?.string(forKey: AppGroupKeys.userName) ?? "Your friend"

        for partner in partners where shouldNotify(partner: partner, type: type) {
            scheduleLocalNotification(
                title: type.title,
                body: type.message(for: userName),
                identifier: "partner_\(partner.id.uuidString)_\(UUID().uuidString.prefix(8))"
            )
            partner.lastNotifiedAt = Date()
        }
    }

    private func shouldNotify(partner: AccountabilityPartner, type: NotificationType) -> Bool {
        switch type {
        case .bypassAttempt: return partner.notifyOnBypassAttempt
        case .emergencyOverride: return partner.notifyOnEmergencyOverride
        case .dailyReport: return partner.notifyOnDailyReport
        case .streakMilestone: return true
        }
    }

    private func scheduleLocalNotification(title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
