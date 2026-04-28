import SwiftUI
import FamilyControls

struct AppSelectionView: View {

    @EnvironmentObject var shieldViewModel: ShieldViewModel
    @State private var showFamilyActivityPicker = false
    @State private var activitySelection = FamilyActivitySelection()
    @State private var showPermissionAlert = false
    @State private var isCheckingPermission = false
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

                if !ShieldManager.shared.isAuthorized {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                            Text("Screen Time Access Required")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }

                        Text("NightGuard needs Screen Time permission to block apps. This is a system requirement for all focus apps.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button {
                            requestPermission()
                        } label: {
                            if isCheckingPermission {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else {
                                Label("Grant Access", systemImage: "lock.open.fill")
                            }
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.orange.opacity(0.15))
                        .foregroundStyle(.orange)
                        .clipShape(Capsule())
                        .disabled(isCheckingPermission)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 32)
                } else {
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
                        if ShieldManager.shared.isAuthorized {
                            showFamilyActivityPicker = true
                        } else {
                            showPermissionAlert = true
                        }
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
                }

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
                ShieldManager.shared.checkAuthorization()
                if let selection = shieldViewModel.selectedApps {
                    activitySelection = selection
                }
            }
            .alert("Permission Required", isPresented: $showPermissionAlert) {
                Button("Open Settings", role: .none) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable Screen Time access in Settings to block apps.")
            }
        }
    }

    private func requestPermission() {
        isCheckingPermission = true
        Task {
            do {
                try await ShieldManager.shared.requestAuthorization()
            } catch {
                showPermissionAlert = true
            }
            isCheckingPermission = false
        }
    }
}
