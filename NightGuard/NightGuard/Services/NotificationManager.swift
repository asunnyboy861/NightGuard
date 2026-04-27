import Foundation
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    func requestNotificationPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    func scheduleBedtimeNotification(at hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Bedtime"
        content.body = "NightGuard is activating. Time to put your phone to sleep."
        content.sound = .default
        content.categoryIdentifier = "BEDTIME"

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "bedtime_schedule", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleWakeUpNotification(at hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Good Morning!"
        content.body = "NightGuard has been deactivated. Have a great day!"
        content.sound = .default
        content.categoryIdentifier = "WAKEUP"

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "wakeup_schedule", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
