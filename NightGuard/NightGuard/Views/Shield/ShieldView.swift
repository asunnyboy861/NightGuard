import SwiftUI
import FamilyControls

struct ShieldView: View {

    @EnvironmentObject var shieldViewModel: ShieldViewModel
    @State private var showFamilyActivityPicker = false
    @State private var activitySelection = FamilyActivitySelection()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: shieldViewModel.isShieldActive
                    ? [Color.indigo.opacity(0.3), Color.purple.opacity(0.3)]
                    : [Color.indigo.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: shieldViewModel.isShieldActive
                                    ? [Color.indigo, Color.purple]
                                    : [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 200, height: 200)
                            .shadow(color: shieldViewModel.isShieldActive ? .indigo.opacity(0.5) : .clear, radius: 20)

                        Image(systemName: shieldViewModel.isShieldActive ? "shield.fill" : "shield")
                            .font(.system(size: 70))
                            .foregroundStyle(.white)
                    }
                    .accessibilityLabel(shieldViewModel.isShieldActive ? "Shield is active" : "Shield is inactive")

                    VStack(spacing: 8) {
                        Text(shieldViewModel.isShieldActive ? "Protection Active" : "Protection Off")
                            .font(.title)
                            .fontWeight(.bold)
                            .accessibleStatus(label: "Protection status", value: shieldViewModel.isShieldActive ? "Active" : "Off")

                        if shieldViewModel.isShieldActive {
                            Text(SimulatedShutdown.shared.remainingTime)
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .accessibleStatus(label: "Time remaining", value: SimulatedShutdown.shared.remainingTime)
                        }
                    }

                    VStack(spacing: 16) {
                        if !shieldViewModel.isShieldActive {
                            Button {
                                showFamilyActivityPicker = true
                            } label: {
                                Label("Select Apps to Block", systemImage: "app.badge.fill")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.indigo)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.horizontal, 32)
                            .accessibleButton(label: "Select apps to block", hint: "Choose which apps to block during bedtime")
                        }

                        Button {
                            if shieldViewModel.isShieldActive {
                                shieldViewModel.stopShield()
                            } else {
                                shieldViewModel.startShieldNow()
                            }
                        } label: {
                            Label(
                                shieldViewModel.isShieldActive ? "Deactivate Shield" : "Activate Shield",
                                systemImage: shieldViewModel.isShieldActive ? "shield.slash" : "shield.fill"
                            )
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(shieldViewModel.isShieldActive ? Color.red : Color.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal, 32)
                        .accessibleButton(
                            label: shieldViewModel.isShieldActive ? "Deactivate shield" : "Activate shield",
                            hint: shieldViewModel.isShieldActive ? "Turns off app blocking until next schedule" : "Starts blocking selected apps now"
                        )

                        if shieldViewModel.isShieldActive {
                            Button("Emergency Override", role: .destructive) {
                                shieldViewModel.emergencyOverride()
                            }
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .accessibleButton(label: "Emergency override", hint: "Disables all protection immediately and notifies your accountability partner")
                        }
                    }

                    Toggle("Hard Lock Mode", isOn: $shieldViewModel.isHardLock)
                        .font(.subheadline)
                        .padding(.horizontal, 32)
                        .accessibleStatus(label: "Hard Lock Mode", value: shieldViewModel.isHardLock ? "On" : "Off")

                    Spacer()
                }
            }
            .navigationTitle("NightGuard")
            .familyActivityPicker(isPresented: $showFamilyActivityPicker, selection: $activitySelection)
            .onChange(of: activitySelection) { _, newValue in
                shieldViewModel.selectedApps = newValue
            }
        }
    }
}
