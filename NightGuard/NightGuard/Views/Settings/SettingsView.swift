import SwiftUI
import SwiftData

struct SettingsView: View {

    @EnvironmentObject var storeManager: StoreManager
    @AppStorage("isOnboarded") private var isOnboarded = false
    @State private var showPaywall = false
    @State private var userName = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Premium") {
                    if storeManager.isPremium {
                        Label("Premium Active", systemImage: "crown.fill")
                            .foregroundStyle(.yellow)
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            Label("Upgrade to Premium", systemImage: "crown")
                                .foregroundStyle(.indigo)
                        }
                    }
                }

                Section("Profile") {
                    HStack {
                        Text("Your Name")
                        Spacer()
                        TextField("Name", text: $userName)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Accountability") {
                    NavigationLink {
                        PartnerView()
                    } label: {
                        Label("Accountability Partner", systemImage: "person.2.fill")
                    }
                }

                Section("Health") {
                    NavigationLink {
                        HealthSettingsView()
                    } label: {
                        Label("Apple Health", systemImage: "heart.fill")
                            .foregroundStyle(.red)
                    }
                }

                Section("Support") {
                    Link(destination: URL(string: "https://asunnyboy861.github.io/NightGuard/support.html")!) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }

                    Link(destination: URL(string: "mailto:iocompile67692@gmail.com")!) {
                        Label("Contact Us", systemImage: "envelope")
                    }

                    Link(destination: URL(string: "https://asunnyboy861.github.io/NightGuard/rate.html")!) {
                        Label("Rate NightGuard", systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }

                Section("Legal") {
                    Link(destination: URL(string: "https://asunnyboy861.github.io/NightGuard/privacy.html")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }

                    Link(destination: URL(string: "https://asunnyboy861.github.io/NightGuard/terms.html")!) {
                        Label("Terms of Use", systemImage: "doc.text")
                    }
                }

                Section {
                    Button("Restore Purchases") {
                        Task { await storeManager.restorePurchases() }
                    }

                    Button("Reset Onboarding", role: .destructive) {
                        isOnboarded = false
                    }
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .onAppear {
                loadUserName()
            }
            .onChange(of: userName) { _, newValue in
                saveUserName(newValue)
            }
        }
    }

    private func loadUserName() {
        let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)
        userName = defaults?.string(forKey: AppGroupKeys.userName) ?? ""
    }

    private func saveUserName(_ name: String) {
        let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)
        defaults?.set(name, forKey: AppGroupKeys.userName)
    }
}

struct HealthSettingsView: View {
    @StateObject private var healthService = HealthKitService.shared
    @State private var isSyncing = false

    var body: some View {
        List {
            Section("Apple Health Integration") {
                if healthService.isAuthorized {
                    HStack {
                        Image(systemName: "heart.circle.fill")
                            .foregroundStyle(.green)
                        Text("Connected")
                        Spacer()
                        Button {
                            Task { await syncData() }
                        } label: {
                            if isSyncing {
                                ProgressView()
                            } else {
                                Text("Sync Now")
                            }
                        }
                    }
                } else {
                    Button {
                        Task {
                            _ = try? await healthService.requestAuthorization()
                        }
                    } label: {
                        Label("Connect to Apple Health", systemImage: "heart.fill")
                    }
                }
            }

            Section {
                Text("NightGuard can sync your sleep data with the Apple Health app. This helps you track your sleep patterns alongside other health metrics.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Apple Health")
    }

    private func syncData() async {
        isSyncing = true
        defer { isSyncing = false }
        _ = try? await healthService.fetchRecentSleepData()
    }
}
