import SwiftUI
import SwiftData

struct PartnerView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var partners: [AccountabilityPartner]
    @State private var showAddPartner = false
    @State private var partnerName = ""

    var body: some View {
        List {
            if partners.isEmpty {
                ContentUnavailableView(
                    "No Partner Yet",
                    systemImage: "person.2.circle",
                    description: Text("Add an accountability partner who will be notified if you try to bypass your bedtime.")
                )
            } else {
                ForEach(partners) { partner in
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.indigo)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(partner.name)
                                .font(.headline)

                            Text("Bypass alerts: \(partner.notifyOnBypassAttempt ? "On" : "Off")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deletePartner)
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
            Button("Add") {
                addPartner()
            }
            Button("Cancel", role: .cancel) {
                partnerName = ""
            }
        } message: {
            Text("Enter your accountability partner's name.")
        }
    }

    private func addPartner() {
        guard !partnerName.isEmpty else { return }
        let partner = AccountabilityPartner(name: partnerName, contactIdentifier: partnerName)
        modelContext.insert(partner)
        partnerName = ""
    }

    private func deletePartner(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(partners[index])
        }
    }
}
