import SwiftUI
import SwiftData

@main
struct NightGuardApp: App {

    @AppStorage("isOnboarded") private var isOnboarded = false

    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([BedtimeSchedule.self, AccountabilityPartner.self, SleepRecord.self, MorningStreak.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if isOnboarded {
                MainTabView()
                    .environmentObject(ShieldViewModel())
                    .environmentObject(StoreManager())
            } else {
                OnboardingView()
            }
        }
        .modelContainer(modelContainer)
    }
}
