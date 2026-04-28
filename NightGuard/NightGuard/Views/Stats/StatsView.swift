import SwiftUI
import SwiftData
import Charts

struct StatsView: View {

    @StateObject private var viewModel = StatsViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTimeRange: SleepChartView.TimeRange = .week

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            title: "Avg Sleep",
                            value: viewModel.formattedAverageSleep,
                            unit: "hrs",
                            icon: "bed.double.fill",
                            color: .indigo
                        )

                        StatCard(
                            title: "Streak",
                            value: "\(viewModel.currentStreak)",
                            unit: "days",
                            icon: "flame.fill",
                            color: .orange
                        )

                        StatCard(
                            title: "Best Streak",
                            value: "\(viewModel.longestStreak)",
                            unit: "days",
                            icon: "trophy.fill",
                            color: .yellow
                        )

                        StatCard(
                            title: "Bypasses",
                            value: "\(viewModel.totalBypassAttempts)",
                            unit: "total",
                            icon: "hand.raised.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)

                    HealthKitCard(
                        isConnected: viewModel.isHealthKitConnected,
                        onConnect: {
                            await viewModel.requestHealthKitAccess()
                        },
                        onSync: {
                            await viewModel.syncUnsyncedRecords(modelContext: modelContext)
                        }
                    )
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Time Range", selection: $selectedTimeRange) {
                            ForEach(SleepChartView.TimeRange.allCases, id: \.self) { range in
                                Text(range.rawValue).tag(range)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)

                        SleepChartView(
                            records: viewModel.recentRecords,
                            timeRange: selectedTimeRange
                        )
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Nights")
                            .font(.headline)
                            .padding(.horizontal)

                        if viewModel.recentRecords.isEmpty {
                            ContentUnavailableView(
                                "No Records Yet",
                                systemImage: "moon.zzz",
                                description: Text("Complete your first night with NightGuard to see stats.")
                            )
                            .padding()
                        } else {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.recentRecords.prefix(7)) { record in
                                    SleepRecordRow(record: record)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Stats")
            .onAppear {
                viewModel.loadStats(modelContext: modelContext)
            }
            .refreshable {
                viewModel.loadStats(modelContext: modelContext)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(unit)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct HealthKitCard: View {
    let isConnected: Bool
    let onConnect: @MainActor () async -> Void
    let onSync: @MainActor () async -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.title2)
                .foregroundStyle(.red)

            if isConnected {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Apple Health Connected")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Sleep data syncing automatically")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    Task { await onSync() }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundStyle(.green)
                }
                .accessibilityLabel("Sync with Apple Health")
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Apple Health")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Connect to sync your sleep data")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button("Connect") {
                    Task { await onConnect() }
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.indigo)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct SleepRecordRow: View {
    let record: SleepRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)

                HStack(spacing: 4) {
                    Image(systemName: "moon.fill")
                        .font(.caption2)
                        .foregroundStyle(.indigo)
                    Text(record.bedtime, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Image(systemName: "arrow.right")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Image(systemName: "sunrise.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text(record.wakeTime, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f", record.durationSeconds / 3600))
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if record.bypassAttemptCount > 0 {
                    HStack(spacing: 2) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption2)
                            .foregroundStyle(.red)
                        Text("\(record.bypassAttemptCount)")
                            .font(.caption2)
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
