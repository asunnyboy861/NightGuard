import ManagedSettings
import UIKit

class ShieldActionExtension: ShieldActionExtension {

    override func handle(
        action: ShieldAction,
        for application: Application,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            AccountabilityService.shared.notifyPartnerOfEmergencyOverride()
            completionHandler(.defer)
        @unknown default:
            completionHandler(.close)
        }
    }

    override func handle(
        action: ShieldAction,
        for webDomain: WebDomain,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            AccountabilityService.shared.notifyPartnerOfEmergencyOverride()
            completionHandler(.defer)
        @unknown default:
            completionHandler(.close)
        }
    }

    override func handle(
        action: ShieldAction,
        for category: ActivityCategory,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            AccountabilityService.shared.notifyPartnerOfEmergencyOverride()
            completionHandler(.defer)
        @unknown default:
            completionHandler(.close)
        }
    }
}
