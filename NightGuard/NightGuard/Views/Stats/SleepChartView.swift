import SwiftUI
import Charts

struct SleepChartView: View {
    let records: [SleepRecord]
    let timeRange: TimeRange

    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"

        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            }
        }
    }

    private var filteredRecords: [SleepRecord] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -timeRange.days, to: Date())!
        return records.filter { $0.date >= cutoffDate }.sorted { $0.date < $1.date }
    }

    private var averageDuration: Double {
        guard !filteredRecords.isEmpty else { return 0 }
        let total = filteredRecords.reduce(0.0) { $0 + $1.durationSeconds }
        return total / Double(filteredRecords.count) / 3600
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Sleep Duration")
                    .font(.headline)

                Spacer()

                Text("Avg: \(String(format: "%.1f", averageDuration))h")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if filteredRecords.isEmpty {
                ContentUnavailableView(
                    "No Data",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Complete more nights to see trends")
                )
                .frame(height: 200)
            } else {
                Chart(filteredRecords) { record in
                    BarMark(
                        x: .value("Date", record.date, unit: .day),
                        y: .value("Hours", record.durationSeconds / 3600)
                    )
                    .foregroundStyle(record.durationSeconds >= 7 * 3600 ? Color.indigo : Color.orange)
                    .cornerRadius(4)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: timeRange == .week ? .day : .weekOfYear)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
