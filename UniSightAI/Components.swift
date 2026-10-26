import SwiftUI

// MARK: - Predicted Grade Ring
struct PredictedGradeRing: View {
    let predicted: Double
    let maxGrade: Double = 10.0

    private var progress: Double { predicted / maxGrade }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color(red: 0.80, green: 0.0, blue: 0.0), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text("PREDICTED")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.secondary)
                Text(String(format: "%.1f", predicted))
                    .font(.system(size: 26, weight: .bold))
                Text("of 10.0")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 110, height: 110)
    }
}

// MARK: - Risk Badge
struct RiskBadge: View {
    let label: String
    let value: String
    let valueColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(valueColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String
    let change: String
    let changePositive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            topRow
            Text(label.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            Text(value)
                .font(.system(size: 20, weight: .bold))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    private var topRow: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(iconColor)
                .frame(width: 30, height: 30)
                .background(iconColor.opacity(0.12))
                .cornerRadius(8)
            Spacer()
            Text(change)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(changePositive ? .green : .orange)
        }
    }
}

// MARK: - Semester Progress Bar
struct SemesterProgressBar: View {
    let week: Int
    let totalWeeks: Int
    let startDate: String
    let endDate: String

    private var progress: Double { Double(week) / Double(totalWeeks) }
    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            headerRow
            progressBar
            dateRow
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    private var headerRow: some View {
        HStack {
            Text("Semester progress")
                .font(.system(size: 15, weight: .semibold))
            Spacer()
            Text("Week \(week) of \(totalWeeks)")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray5))
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 6)
                    .fill(LinearGradient(colors: [uniRed, Color(red: 1.0, green: 0.3, blue: 0.3)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: geo.size.width * progress, height: 10)
            }
        }
        .frame(height: 10)
    }

    private var dateRow: some View {
        HStack {
            Text("Started · \(startDate)")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Spacer()
            Text("\(Int(progress * 100))% complete")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(uniRed)
            Spacer()
            Text("Ends · \(endDate)")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
}
