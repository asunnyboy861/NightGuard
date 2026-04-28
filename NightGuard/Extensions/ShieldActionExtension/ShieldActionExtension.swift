import ManagedSettings
import FamilyControls
import Foundation

class ShieldActionExtension: ShieldActionDelegate {

    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            let defaults = UserDefaults(suiteName: "group.com.zzoutuo.NightGuard.shared")
            defaults?.set(true, forKey: "emergency_override_requested")
            defaults?.set(Date(), forKey: "emergency_override_time")
            completionHandler(.defer)
        @unknown default:
            completionHandler(.close)
        }
    }

    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            let defaults = UserDefaults(suiteName: "group.com.zzoutuo.NightGuard.shared")
            defaults?.set(true, forKey: "emergency_override_requested")
            defaults?.set(Date(), forKey: "emergency_override_time")
            completionHandler(.defer)
        @unknown default:
            completionHandler(.close)
        }
    }

    override func handle(
        action: ShieldAction,
        for category: ActivityCategoryToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            let defaults = UserDefaults(suiteName: "group.com.zzoutuo.NightGuard.shared")
            defaults?.set(true, forKey: "emergency_override_requested")
            defaults?.set(Date(), forKey: "emergency_override_time")
            completionHandler(.defer)
        @unknown default:
            completionHandler(.close)
        }
    }
}
