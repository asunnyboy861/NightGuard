import SwiftUI
import FamilyControls

struct AppSelectionView: View {

    @EnvironmentObject var shieldViewModel: ShieldViewModel
    @State private var showFamilyActivityPicker = false
    @State private var activitySelection = FamilyActivitySelection()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "app.badge.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.indigo)

                Text("Select Apps to Block")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Choose the apps and websites that distract you at night. NightGuard will block them during your scheduled bedtime.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                if !activitySelection.applicationTokens.isEmpty {
                    VStack(spacing: 8) {
                        Label {
                            Text("\(activitySelection.applicationTokens.count) apps selected")
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                        .font(.subheadline)

                        if !activitySelection.categoryTokens.isEmpty {
                            Label {
                                Text("\(activitySelection.categoryTokens.count) categories selected")
                            } icon: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                            .font(.subheadline)
                        }
                    }
                }

                Button {
                    showFamilyActivityPicker = true
                } label: {
                    Label(activitySelection.applicationTokens.isEmpty ? "Choose Apps" : "Change Selection", systemImage: "square.grid.2x2")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.indigo)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 32)

                Spacer()
            }
            .padding(.vertical, 40)
            .navigationTitle("App Selection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .familyActivityPicker(isPresented: $showFamilyActivityPicker, selection: $activitySelection)
            .onChange(of: activitySelection) { _, newValue in
                shieldViewModel.selectedApps = newValue
            }
            .onAppear {
                if let selection = shieldViewModel.selectedApps {
                    activitySelection = selection
                }
            }
        }
    }
}
