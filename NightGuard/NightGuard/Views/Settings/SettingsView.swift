import SwiftUI
import SwiftData

struct SettingsView: View {

    @EnvironmentObject var storeManager: StoreManager
    @AppStorage("isOnboarded") private var isOnboarded = false
    @State private var showPaywall = false

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

                Section("Accountability") {
                    NavigationLink {
                        PartnerView()
                    } label: {
                        Label("Accountability Partner", systemImage: "person.2.fill")
                    }
                }

                Section("Support") {
                    Link(destination: URL(string: "https://asunnyboy861.github.io/NightGuard/support.html")!) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }

                    Link(destination: URL(string: "mailto:iocompile67692@gmail.com")!) {
                        Label("Contact Us", systemImage: "envelope")
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
        }
    }
}
