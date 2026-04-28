import HealthKit
import Foundation

@MainActor
final class HealthKitService: ObservableObject {

    static let shared = HealthKitService()

    @Published var isAuthorized = false

    private let healthStore = HKHealthStore()
    private let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!

    private init() {
        checkAuthorizationStatus()
    }

    func requestAuthorization() async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }

        let readTypes: Set<HKObjectType> = [sleepType]
        let shareTypes: Set<HKSampleType> = [sleepType]

        try await healthStore.requestAuthorization(toShare: shareTypes, read: readTypes)

        checkAuthorizationStatus()
        return isAuthorized
    }

    func saveSleepAnalysis(startDate: Date, endDate: Date) async throws {
        guard isAuthorized else { return }

        let sample = HKCategorySample(
            type: sleepType,
            value: HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue,
            start: startDate,
            end: endDate
        )

        try await healthStore.save(sample)
    }

    func fetchRecentSleepData(days: Int = 7) async throws -> [HKCategorySample] {
        guard isAuthorized else { return [] }

        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: endDate)!

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: sleepType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (samples as? [HKCategorySample]) ?? [])
                }
            }
            healthStore.execute(query)
        }
    }

    private func checkAuthorizationStatus() {
        let status = healthStore.authorizationStatus(for: sleepType)
        isAuthorized = status == .sharingAuthorized
    }
}
