import SwiftUI
import SwiftData

struct PartnerView: View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AccountabilityPartner.createdAt, order: .reverse)
    private var partners: [AccountabilityPartner]

    @State private var showAddPartner = false
    @State private var partnerName = ""
    @State private var partnerContact = ""
    @State private var partnerContactType: ContactType = .message
    @State private var partnerRelationship = ""

    var body: some View {
        List {
            if partners.isEmpty {
                ContentUnavailableView(
                    "No Partner Yet",
                    systemImage: "person.2.circle",
                    description: Text("Add an accountability partner who will be notified when you need support staying on track.")
                )
            } else {
                Section("Active Partners") {
                    ForEach(partners) { partner in
                        PartnerCardView(partner: partner)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    modelContext.delete(partner)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }

                Section("Notification Settings") {
                    ForEach(partners) { partner in
                        PartnerNotificationRow(partner: partner)
                    }
                }
            }
        }
        .navigationTitle("Accountability Partner")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddPartner = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("Add Partner", isPresented: $showAddPartner) {
            TextField("Name", text: $partnerName)
            TextField("Phone or Email", text: $partnerContact)
            TextField("Relationship (optional)", text: $partnerRelationship)
            Picker("Contact Type", selection: $partnerContactType) {
                ForEach(ContactType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            Button("Add") {
                addPartner()
            }
            .disabled(partnerName.isEmpty || partnerContact.isEmpty)
            Button("Cancel", role: .cancel) {
                resetForm()
            }
        } message: {
            Text("Enter your accountability partner's contact info.")
        }
    }

    private func addPartner() {
        guard !partnerName.isEmpty, !partnerContact.isEmpty else { return }
        let partner = AccountabilityPartner(
            name: partnerName,
            contactIdentifier: partnerContact,
            contactType: partnerContactType,
            relationship: partnerRelationship.isEmpty ? nil : partnerRelationship
        )
        modelContext.insert(partner)
        resetForm()
    }

    private func resetForm() {
        partnerName = ""
        partnerContact = ""
        partnerRelationship = ""
        partnerContactType = .message
    }
}

struct PartnerNotificationRow: View {
    let partner: AccountabilityPartner

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(partner.name)
                .font(.subheadline)
                .fontWeight(.medium)

            Toggle("Bypass Alerts", isOn: Binding(
                get: { partner.notifyOnBypassAttempt },
                set: { partner.notifyOnBypassAttempt = $0 }
            ))
            .font(.caption)

            Toggle("Override Alerts", isOn: Binding(
                get: { partner.notifyOnEmergencyOverride },
                set: { partner.notifyOnEmergencyOverride = $0 }
            ))
            .font(.caption)

            Toggle("Daily Report", isOn: Binding(
                get: { partner.notifyOnDailyReport },
                set: { partner.notifyOnDailyReport = $0 }
            ))
            .font(.caption)
        }
        .padding(.vertical, 4)
    }
}
