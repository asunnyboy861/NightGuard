import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

@MainActor
final class ShieldManager: ObservableObject {

    static let shared = ShieldManager()

    private let authorizationCenter = AuthorizationCenter.shared
    private let managedSettingsStore = ManagedSettingsStore()

    @Published var isAuthorized = false
    @Published var selectedApps: FamilyActivitySelection?

    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

    func requestAuthorization() async throws {
        do {
            try await authorizationCenter.requestAuthorization(for: .individual)
            isAuthorized = true
        } catch {
            throw error
        }
    }

    func checkAuthorization() {
        isAuthorized = authorizationCenter.authorizationStatus == .approved
    }

    func applyBedtimeShield(selection: FamilyActivitySelection) {
        managedSettingsStore.shield.applications = selection.applicationTokens
        managedSettingsStore.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selection.categoryTokens)
        managedSettingsStore.shield.webDomains = selection.webDomainTokens

        saveSelectionToAppGroup(selection)

        defaults?.set(true, forKey: AppGroupKeys.isShieldActive)
        defaults?.set(Date(), forKey: AppGroupKeys.shieldAppliedAt)
    }

    func removeBedtimeShield() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil
        managedSettingsStore.shield.webDomains = nil

        clearAppGroupSelection()
    }

    func applyFullShield() {
        managedSettingsStore.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy<Application>.all(except: [])

        defaults?.set(true, forKey: AppGroupKeys.isShieldActive)
        defaults?.set(true, forKey: AppGroupKeys.shutdownStarted)
        defaults?.set(Date(), forKey: AppGroupKeys.shieldAppliedAt)
    }

    private func saveSelectionToAppGroup(_ selection: FamilyActivitySelection) {
        guard let defaults else { return }
        do {
            let data = try JSONEncoder().encode(selection)
            defaults.set(data, forKey: AppGroupKeys.activitySelection)
        } catch {
            print("Failed to encode selection: \(error)")
        }
    }

    private func clearAppGroupSelection() {
        defaults?.removeObject(forKey: AppGroupKeys.activitySelection)
        defaults?.set(false, forKey: AppGroupKeys.isShieldActive)
        defaults?.set(false, forKey: AppGroupKeys.shutdownStarted)
    }
}
