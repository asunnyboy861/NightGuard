import AppIntents

struct StopNightGuardIntent: AppIntent {

    static var title: LocalizedStringResource = "Stop NightGuard"
    static var description = IntentDescription("Deactivate NightGuard bedtime protection.")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        let shieldManager = ShieldManager.shared
        await shieldManager.removeBedtimeShield()
        ChainScheduler.shared.stopChainMonitoring()
        await SimulatedShutdown.shared.endShutdown()

        return .result(dialog: "NightGuard has been deactivated. Good morning!")
    }
}
