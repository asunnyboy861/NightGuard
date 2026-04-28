import SwiftUI

struct ScheduleSetupView: View {

    @StateObject private var viewModel = ScheduleViewModel()
    @State private var showSaveConfirmation = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Sleep Schedule") {
                    DatePicker(
                        "Bedtime",
                        selection: $viewModel.bedtime,
                        displayedComponents: .hourAndMinute
                    )

                    DatePicker(
                        "Wake Up",
                        selection: $viewModel.wakeUpTime,
                        displayedComponents: .hourAndMinute
                    )

                    HStack {
                        Text("Duration")
                        Spacer()
                        Text(viewModel.sleepDurationText)
                            .foregroundStyle(.secondary)
                            .fontWeight(.medium)
                    }
                }

                Section("Repeat") {
                    HStack(spacing: 8) {
                        ForEach(1...7, id: \.self) { day in
                            DayButton(
                                name: viewModel.weekdayNames[day - 1],
                                isSelected: viewModel.selectedWeekdays.contains(day)
                            ) {
                                viewModel.toggleWeekday(day)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }

                Section("Smart Reminders") {
                    Toggle("Wind Down Reminder", isOn: $viewModel.enableWindDownReminder)

                    if viewModel.enableWindDownReminder {
                        Stepper(
                            "\(viewModel.windDownMinutes) min before bedtime",
                            value: $viewModel.windDownMinutes,
                            in: 15...120,
                            step: 15
                        )
                    }

                    Toggle("Wake Up Notification", isOn: $viewModel.enableWakeUpNotification)
                }

                Section("Protection") {
                    Toggle("Hard Lock Mode", isOn: $viewModel.isHardLock)
                    Text("Hard Lock makes it nearly impossible to bypass your bedtime protection.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Toggle("Enable Schedule", isOn: $viewModel.isEnabled)
                }

                Section {
                    Button("Save Schedule") {
                        viewModel.saveSchedule()
                        showSaveConfirmation = true
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.indigo)
                }
            }
            .navigationTitle("Schedule")
            .alert("Schedule Saved", isPresented: $showSaveConfirmation) {
                Button("OK") { }
            } message: {
                Text("Your bedtime schedule has been saved and notifications have been updated.")
            }
        }
    }
}

struct DayButton: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.indigo : Color.gray.opacity(0.2))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(name)\(isSelected ? ", selected" : "")")
        .accessibilityHint("Double tap to \(isSelected ? "deselect" : "select")")
    }
}
