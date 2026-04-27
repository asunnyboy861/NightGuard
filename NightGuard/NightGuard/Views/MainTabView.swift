import SwiftUI

struct MainTabView: View {

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ShieldView()
                .tabItem {
                    Label("Shield", systemImage: "shield.fill")
                }
                .tag(0)

            ScheduleSetupView()
                .tabItem {
                    Label("Schedule", systemImage: "clock.fill")
                }
                .tag(1)

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.indigo)
    }
}
