import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {

    @Published var currentPage = 0
    @Published var hasAuthorized = false
    @Published var hasSelectedApps = false

    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Take Back Your Nights",
            subtitle: "NightGuard helps you build healthy phone habits by blocking distracting apps at bedtime.",
            iconName: "moon.stars.fill",
            gradient: [Color.indigo, Color.purple]
        ),
        OnboardingPage(
            title: "Set Your Schedule",
            subtitle: "Choose your bedtime and wake-up time. NightGuard will automatically protect your sleep every night.",
            iconName: "clock.fill",
            gradient: [Color.purple, Color.pink]
        ),
        OnboardingPage(
            title: "Hard Lock Mode",
            subtitle: "Enable Hard Lock to make it nearly impossible to bypass your bedtime. Your future self will thank you.",
            iconName: "lock.shield.fill",
            gradient: [Color.pink, Color.orange]
        ),
        OnboardingPage(
            title: "Accountability Partner",
            subtitle: "Add a friend who gets notified if you try to bypass your bedtime. Stay honest, sleep better.",
            iconName: "person.2.fill",
            gradient: [Color.orange, Color.yellow]
        )
    ]

    var isLastPage: Bool {
        currentPage == pages.count - 1
    }

    var shouldShowAuthorization: Bool {
        currentPage == 1
    }

    func nextPage() {
        withAnimation { currentPage += 1 }
    }

    func previousPage() {
        withAnimation { currentPage -= 1 }
    }

    func completeOnboarding() {
        defaults?.set(true, forKey: AppGroupKeys.isOnboarded)
        UserDefaults.standard.set(true, forKey: AppGroupKeys.isOnboarded)
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let iconName: String
    let gradient: [Color]
}
