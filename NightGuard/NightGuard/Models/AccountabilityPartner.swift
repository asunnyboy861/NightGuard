import Foundation
import SwiftData

@Model
final class AccountabilityPartner {
    var id: UUID
    var name: String
    var contactIdentifier: String
    var notifyOnBypassAttempt: Bool
    var notifyOnEmergencyOverride: Bool

    init(name: String, contactIdentifier: String) {
        self.id = UUID()
        self.name = name
        self.contactIdentifier = contactIdentifier
        self.notifyOnBypassAttempt = true
        self.notifyOnEmergencyOverride = true
    }
}
