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

                    VStack(spacing: 8) {
                        Text(shieldViewModel.isShieldActive ? "Protection Active" : "Protection Off")
                            .font(.title)
                            .fontWeight(.bold)

                        if shieldViewModel.isShieldActive {
                            Text(SimulatedShutdown.shared.remainingTime)
                                .font(.title2)
                                .foregroundStyle(.secondary)
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

                        if shieldViewModel.isShieldActive {
                            Button("Emergency Override", role: .destructive) {
                                shieldViewModel.emergencyOverride()
                            }
                            .font(.subheadline)
                            .foregroundStyle(.red)
                        }
                    }

                    Toggle("Hard Lock Mode", isOn: $shieldViewModel.isHardLock)
                        .font(.subheadline)
                        .padding(.horizontal, 32)

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
