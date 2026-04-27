import SwiftUI

struct ScheduleSetupView: View {

    @StateObject private var viewModel = ScheduleViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Bedtime") {
                    HStack {
                        Text("Sleep at")
                        Spacer()
                        Picker("Hour", selection: $viewModel.bedtimeHour) {
                            ForEach(0..<24) { Text("\($0)").tag($0) }
                        }
                        .pickerStyle(.menu)
                        Text(":")
                        Picker("Minute", selection: $viewModel.bedtimeMinute) {
                            ForEach(0..<60) { Text(String(format: "%02d", $0)).tag($0) }
                        }
                        .pickerStyle(.menu)
                    }
                }

                Section("Wake Up") {
                    HStack {
                        Text("Wake at")
                        Spacer()
                        Picker("Hour", selection: $viewModel.wakeUpHour) {
                            ForEach(0..<24) { Text("\($0)").tag($0) }
                        }
                        .pickerStyle(.menu)
                        Text(":")
                        Picker("Minute", selection: $viewModel.wakeUpMinute) {
                            ForEach(0..<60) { Text(String(format: "%02d", $0)).tag($0) }
                        }
                        .pickerStyle(.menu)
                    }

                    HStack {
                        Text("Sleep Duration")
                        Spacer()
                        Text(viewModel.sleepDurationText)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Repeat") {
                    HStack(spacing: 8) {
                        ForEach(1...7, id: \.self) { day in
                            Circle()
                                .fill(viewModel.selectedWeekdays.contains(day) ? Color.indigo : Color.gray.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Text(viewModel.weekdayNames[day - 1])
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(viewModel.selectedWeekdays.contains(day) ? .white : .primary)
                                }
                                .onTapGesture {
                                    withAnimation { viewModel.toggleWeekday(day) }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }

                Section("Lock Mode") {
                    Toggle("Hard Lock", isOn: $viewModel.isHardLock)
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
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.indigo)
                }
            }
            .navigationTitle("Schedule")
        }
    }
}
