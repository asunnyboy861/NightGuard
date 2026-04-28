import Foundation
import SwiftData

enum ContactType: String, Codable, CaseIterable {
    case phone = "Phone"
    case email = "Email"
    case message = "Message"

    var icon: String {
        switch self {
        case .phone: return "phone.fill"
        case .email: return "envelope.fill"
        case .message: return "message.fill"
        }
    }
}

@Model
final class AccountabilityPartner {
    var id: UUID
    var name: String
    var contactIdentifier: String
    var contactTypeRaw: String
    var notifyOnBypassAttempt: Bool
    var notifyOnEmergencyOverride: Bool
    var notifyOnDailyReport: Bool
    var relationship: String?
    var createdAt: Date
    var lastNotifiedAt: Date?

    var contactType: ContactType {
        get { ContactType(rawValue: contactTypeRaw) ?? .message }
        set { contactTypeRaw = newValue.rawValue }
    }

    var isValidContact: Bool {
        switch contactType {
        case .phone:
            let phoneRegex = "^\\+?[0-9\\s\\-\\(\\)]{10,}$"
            return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: contactIdentifier)
        case .email:
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: contactIdentifier)
        case .message:
            return !contactIdentifier.isEmpty
        }
    }

    init(name: String,
         contactIdentifier: String,
         contactType: ContactType = .message,
         relationship: String? = nil) {
        self.id = UUID()
        self.name = name
        self.contactIdentifier = contactIdentifier
        self.contactTypeRaw = contactType.rawValue
        self.notifyOnBypassAttempt = true
        self.notifyOnEmergencyOverride = true
        self.notifyOnDailyReport = false
        self.relationship = relationship
        self.createdAt = Date()
    }
}
