import Foundation
import UserNotifications

final class AccountabilityService {

    static let shared = AccountabilityService()

    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

    func notifyPartnerOfBypassAttempt(at date: Date) {
        guard let defaults,
              defaults.bool(forKey: "partner_notify_bypass") else { return }

        scheduleLocalNotification(
            title: "Bypass Attempt Blocked",
            body: "NightGuard blocked an attempt to open a blocked app. Stay strong!",
            at: date
        )

        incrementBypassCount()
    }

    func notifyPartnerOfEmergencyOverride() {
        guard let defaults,
              defaults.bool(forKey: "partner_notify_override") else { return }

        let userName = defaults.string(forKey: AppGroupKeys.userName) ?? "Your friend"

        scheduleLocalNotification(
            title: "Emergency Override Used",
            body: "\(userName) used Emergency Override. Check in on them?",
            at: Date()
        )
    }

    func scheduleBedtimeReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Bedtime Approaching"
        content.body = "NightGuard will activate soon. Time to wind down."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "bedtime_reminder",
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleWakeUpNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Good Morning!"
        content.body = "NightGuard has been deactivated. Have a great day!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "wake_up",
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func scheduleLocalNotification(title: String, body: String, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func incrementBypassCount() {
        let currentCount = defaults?.integer(forKey: AppGroupKeys.bypassAttempts) ?? 0
        defaults?.set(currentCount + 1, forKey: AppGroupKeys.bypassAttempts)
    }
}
