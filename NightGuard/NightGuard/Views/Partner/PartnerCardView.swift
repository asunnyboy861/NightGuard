import SwiftUI

struct PartnerCardView: View {
    let partner: AccountabilityPartner
    var onEdit: () -> Void = {}
    var onDelete: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.indigo)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(partner.name)
                    .font(.headline)

                HStack(spacing: 4) {
                    Image(systemName: partner.contactType.icon)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(partner.contactIdentifier)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if let relationship = partner.relationship {
                    Text(relationship)
                        .font(.caption2)
                        .foregroundStyle(.indigo)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.indigo.opacity(0.1))
                        .clipShape(Capsule())
                }
            }

            Spacer()

            Image(systemName: partner.isValidContact ? "checkmark.shield.fill" : "exclamationmark.shield")
                .foregroundStyle(partner.isValidContact ? .green : .orange)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(partner.name), \(partner.contactType.rawValue) contact, \(partner.isValidContact ? "verified" : "unverified")")
    }
}
