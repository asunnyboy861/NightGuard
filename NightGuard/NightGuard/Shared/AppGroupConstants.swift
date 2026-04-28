import Foundation

enum AppGroupConstants {
    static let suiteName = "group.com.zzoutuo.NightGuard.shared"
}

enum AppGroupKeys {
    static let activitySelection = "activitySelection"
    static let isShieldActive = "isShieldActive"
    static let shieldAppliedAt = "shieldAppliedAt"
    static let scheduledEndTime = "scheduledEndTime"
    static let chainActive = "chainActive"
    static let bypassAttempts = "bypassAttempts"
    static let shutdownStarted = "shutdownStarted"
    static let partnerData = "partnerData"
    static let userName = "userName"
    static let isHardLock = "isHardLock"
    static let currentChainSlot = "currentChainSlot"
    static let bedtimeHour = "bedtimeHour"
    static let bedtimeMinute = "bedtimeMinute"
    static let wakeUpHour = "wakeUpHour"
    static let wakeUpMinute = "wakeUpMinute"
    static let selectedWeekdays = "selectedWeekdays"
    static let scheduleEnabled = "scheduleEnabled"
    static let windDownReminderEnabled = "wind_down_reminder_enabled"
    static let windDownMinutes = "wind_down_minutes"
    static let wakeUpNotificationEnabled = "wake_up_notification_enabled"
    static let isOnboarded = "isOnboarded"
    static let isPremium = "isPremium"
    static let premiumProductID = "premiumProductID"
}

enum NightGuardProduct: String, CaseIterable {
    case monthly = "com.zzoutuo.NightGuard.monthly"
    case yearly = "com.zzoutuo.NightGuard.yearly"
    case lifetime = "com.zzoutuo.NightGuard.lifetime"
}
