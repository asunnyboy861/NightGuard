import DeviceActivity
import Foundation

final class ChainScheduler {

    static let shared = ChainScheduler()

    private let center = DeviceActivityCenter()
    private let maxSlotDuration: TimeInterval = 44 * 60
    private let totalSlots = 5

    private let defaults = UserDefaults(suiteName: AppGroupConstants.suiteName)

    private var slotNames: [DeviceActivityName] {
        (0..<totalSlots).map { DeviceActivityName("nightguard_slot_\($0)") }
    }

    func startChainMonitoring(from startTime: Date, until endTime: Date) {
        let totalDuration = endTime.timeIntervalSince(startTime)
        guard totalDuration > 0 else { return }

        let numberOfSlots = Int(ceil(totalDuration / maxSlotDuration))
        let slotDuration = min(totalDuration / Double(numberOfSlots), maxSlotDuration)

        center.stopMonitoring()

        let currentSlot = 0
        scheduleSlot(index: currentSlot, start: startTime, duration: slotDuration, totalSlots: numberOfSlots)

        defaults?.set(true, forKey: AppGroupKeys.chainActive)
        defaults?.set(currentSlot, forKey: AppGroupKeys.currentChainSlot)
        defaults?.set(endTime, forKey: AppGroupKeys.scheduledEndTime)
    }

    private func scheduleSlot(index: Int, start: Date, duration: TimeInterval, totalSlots: Int) {
        guard index < totalSlots, index < slotNames.count else {
            defaults?.set(false, forKey: AppGroupKeys.chainActive)
            return
        }

        let endOfSlot = start.addingTimeInterval(duration)
        let scheduleEnd = Calendar.current.startOfDay(for: start).addingTimeInterval(24 * 3600)

        let componentsStart = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: start)
        let componentsEnd = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: min(endOfSlot, scheduleEnd))

        let schedule = DeviceActivitySchedule(
            intervalStart: componentsStart,
            intervalEnd: componentsEnd,
            repeats: false,
            warningTime: nil
        )

        do {
            try center.startMonitoring(slotNames[index], during: schedule)
            defaults?.set(index, forKey: AppGroupKeys.currentChainSlot)
        } catch {
            print("Failed to start monitoring slot \(index): \(error)")
        }
    }

    func handleSlotEnded(slotIndex: Int) {
        guard let endTime = defaults?.object(forKey: AppGroupKeys.scheduledEndTime) as? Date else {
            defaults?.set(false, forKey: AppGroupKeys.chainActive)
            return
        }

        let now = Date()
        if now >= endTime {
            defaults?.set(false, forKey: AppGroupKeys.chainActive)
            return
        }

        let remainingDuration = endTime.timeIntervalSince(now)
        let nextSlotDuration = min(remainingDuration, maxSlotDuration)
        let nextSlotIndex = (slotIndex + 1) % totalSlots

        scheduleSlot(index: nextSlotIndex, start: now, duration: nextSlotDuration, totalSlots: Int(ceil(remainingDuration / maxSlotDuration)))
    }

    func stopChainMonitoring() {
        center.stopMonitoring()
        defaults?.set(false, forKey: AppGroupKeys.chainActive)
        defaults?.removeObject(forKey: AppGroupKeys.currentChainSlot)
        defaults?.removeObject(forKey: AppGroupKeys.scheduledEndTime)
    }
}
