import SwiftUI

struct AdminStudent: Identifiable {
    let id = UUID()
    let name: String
    let program: String
    let year: Int
    let gpa: Double
    let attendance: Double
    let riskLevel: RiskLevel
    let trend: Trend
    let lastActive: String
    let pendingAlerts: Int
    let riskReason: String
    let recentGrades: [Double]
    let lastContact: Int // days ago
}

extension AdminStudent {
    static let sampleList: [AdminStudent] = [
        AdminStudent(name: "Besart Krasniqi", program: "Computer Science", year: 2, gpa: 6.1, attendance: 71, riskLevel: .high, trend: .declining, lastActive: "3 days ago", pendingAlerts: 3, riskReason: "Attendance ↓", recentGrades: [8,7,7,6], lastContact: 12),
        AdminStudent(name: "Genta Loshi", program: "Computer Science", year: 2, gpa: 5.8, attendance: 65, riskLevel: .high, trend: .declining, lastActive: "5 days ago", pendingAlerts: 4, riskReason: "3 missed deadlines", recentGrades: [7,7,6,6], lastContact: 8),
        AdminStudent(name: "Jeta Rama", program: "Computer Science", year: 2, gpa: 6.5, attendance: 74, riskLevel: .high, trend: .declining, lastActive: "4 days ago", pendingAlerts: 2, riskReason: "Failed midterm", recentGrades: [8,7,7,6], lastContact: 5),
        AdminStudent(name: "Drita Morina", program: "Computer Science", year: 3, gpa: 7.8, attendance: 88, riskLevel: .medium, trend: .stable, lastActive: "Yesterday", pendingAlerts: 1, riskReason: "GPA trending down", recentGrades: [8,8,8,7], lastContact: 3),
        AdminStudent(name: "Ilir Mustafa", program: "Computer Science", year: 1, gpa: 7.2, attendance: 82, riskLevel: .medium, trend: .stable, lastActive: "Yesterday", pendingAlerts: 1, riskReason: "Low engagement", recentGrades: [7,7,8,7], lastContact: 7),
        AdminStudent(name: "Anila Hajdini", program: "Computer Science", year: 3, gpa: 8.4, attendance: 94, riskLevel: .low, trend: .rising, lastActive: "Today", pendingAlerts: 0, riskReason: "On track", recentGrades: [8,8,9,9], lastContact: 1),
        AdminStudent(name: "Fitim Berisha", program: "Computer Science", year: 1, gpa: 9.0, attendance: 98, riskLevel: .low, trend: .rising, lastActive: "Today", pendingAlerts: 0, riskReason: "Excellent", recentGrades: [9,9,9,10], lastContact: 2),
        AdminStudent(name: "Hana Syla", program: "Computer Science", year: 3, gpa: 8.9, attendance: 96, riskLevel: .low, trend: .rising, lastActive: "Today", pendingAlerts: 0, riskReason: "Top performer", recentGrades: [9,9,10,9], lastContact: 1),
    ]
}

struct AdminDashboardView: View {
    @Binding var isLoggedIn: Bool
    @State private var searchText = ""
    @State private var selectedRisk = 0
    @State private var selectedStudent: AdminStudent? = nil
    @State private var sortBy = 0

    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)
    let riskFilters = ["All", "High", "Medium", "Low"]
    let sortOptions = ["Risk", "GPA", "Attendance", "Last Active"]

    private var highCount: Int { AdminStudent.sampleList.filter { $0.riskLevel == .high }.count }
    private var medCount: Int { AdminStudent.sampleList.filter { $0.riskLevel == .medium }.count }
    private var lowCount: Int { AdminStudent.sampleList.filter { $0.riskLevel == .low }.count }
    private var needsAttention: Int { AdminStudent.sampleList.filter { $0.pendingAlerts > 0 }.count }

    private var filtered: [AdminStudent] {
        var list = AdminStudent.sampleList
        if selectedRisk > 0 {
            let levels: [RiskLevel] = [.high, .medium, .low]
            list = list.filter { $0.riskLevel == levels[selectedRisk - 1] }
        }
        if !searchText.isEmpty {
            list = list.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        switch sortBy {
        case 1: list.sort { $0.gpa < $1.gpa }
        case 2: list.sort { $0.attendance < $1.attendance }
        case 3: list.sort { $0.lastActive > $1.lastActive }
        default:
            list.sort {
                let order: [RiskLevel: Int] = [.high: 0, .medium: 1, .low: 2]
                return (order[$0.riskLevel] ?? 2) < (order[$1.riskLevel] ?? 2)
            }
        }
        return list
    }

    var body: some View {
        ZStack(alignment: .top) {
            uniRed.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Header
                    headerBar

                    // MARK: - Cohort Hero
                    cohortHero
                        .padding(.horizontal, 20)
                        .padding(.bottom, 36)

                    // MARK: - White content
                    VStack(spacing: 16) {

                        // Action Queue
                        actionQueue

                        // Risk Distribution
                        riskDistribution

                        // Search + Sort
                        searchBar
                        sortBar

                        // Filter tabs
                        filterTabs

                        // Student List
                        if filtered.isEmpty {
                            emptyState
                        } else {
                            VStack(spacing: 10) {
                                ForEach(filtered) { student in
                                    studentCard(student: student)
                                        .onTapGesture { selectedStudent = student }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                }
            }
        }
        .sheet(item: $selectedStudent) { student in
            StudentDetailView(student: student)
        }
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            Spacer()
            Text("Coordinator Panel")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            Button(action: { isLoggedIn = false }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.trailing, 20)
        }
        .padding(.top, 60)
        .padding(.bottom, 20)
    }

    // MARK: - Cohort Hero
    private var cohortHero: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SPRING 2026")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .tracking(1.5)
                    Text("Computer Science")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("\(AdminStudent.sampleList.count) students enrolled")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.75))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(needsAttention)")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text("needs attention\ntoday")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    // MARK: - Action Queue
    private var actionQueue: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's action queue")
                .font(.system(size: 15, weight: .bold))

            VStack(spacing: 8) {
                actionRow(icon: "person.badge.exclamationmark.fill", color: uniRed, text: "\(highCount) students to contact", sub: "High risk — no contact in 7+ days")
                actionRow(icon: "clock.badge.exclamationmark.fill", color: .orange, text: "2 overdue interventions", sub: "Follow-up required from last week")
                actionRow(icon: "calendar.badge.plus", color: .blue, text: "1 meeting scheduled today", sub: "Besart Krasniqi · 14:00")
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    // MARK: - Risk Distribution
    private var riskDistribution: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Risk distribution")
                    .font(.system(size: 15, weight: .bold))
                Spacer()
                HStack(spacing: 12) {
                    legendDot(color: .red, label: "High \(highCount)")
                    legendDot(color: .orange, label: "Med \(medCount)")
                    legendDot(color: .green, label: "Low \(lowCount)")
                }
            }

            GeometryReader { geo in
                HStack(spacing: 2) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.red)
                        .frame(width: geo.size.width * CGFloat(highCount) / CGFloat(AdminStudent.sampleList.count))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.orange)
                        .frame(width: geo.size.width * CGFloat(medCount) / CGFloat(AdminStudent.sampleList.count))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.green)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 10)
            }
            .frame(height: 10)

            Text("↑ 2 students moved to High risk this week")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    // MARK: - Search
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search student...", text: $searchText)
                .disableAutocorrection(true)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    // MARK: - Sort Bar
    private var sortBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<sortOptions.count, id: \.self) { i in
                    Button(action: { sortBy = i }) {
                        HStack(spacing: 4) {
                            if sortBy == i {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.system(size: 10))
                            }
                            Text(sortOptions[i])
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(sortBy == i ? .white : .primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(sortBy == i ? uniRed : Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 2)
        }
    }

    // MARK: - Filter Tabs
    private var filterTabs: some View {
        HStack(spacing: 0) {
            ForEach(0..<riskFilters.count, id: \.self) { i in
                Button(action: { selectedRisk = i }) {
                    Text(riskFilters[i])
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedRisk == i ? .white : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedRisk == i ? uniRed : Color.clear)
                        .cornerRadius(12)
                }
            }
        }
        .padding(4)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    // MARK: - Student Card
    private func studentCard(student: AdminStudent) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(riskColor(student.riskLevel).opacity(0.12))
                        .frame(width: 46, height: 46)
                    Text(student.name.components(separatedBy: " ").compactMap { $0.first }.prefix(2).map(String.init).joined())
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(riskColor(student.riskLevel))
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(student.name)
                            .font(.system(size: 14, weight: .bold))
                        Spacer()
                        // Risk pill
                        Text(student.riskLevel.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(riskColor(student.riskLevel))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(riskColor(student.riskLevel).opacity(0.1))
                            .cornerRadius(8)
                    }

                    HStack(spacing: 8) {
                        Text("GPA: \(String(format: "%.1f", student.gpa))")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("·")
                            .foregroundColor(.secondary)
                        Text("Att: \(Int(student.attendance))%")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("·")
                            .foregroundColor(.secondary)
                        // Sparkline
                        MiniSparkline(grades: student.recentGrades, color: trendColor(student.trend))
                            .frame(width: 36, height: 14)
                    }

                    HStack(spacing: 6) {
                        // Risk reason chip
                        Text(student.riskReason)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(riskColor(student.riskLevel))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(riskColor(student.riskLevel).opacity(0.08))
                            .cornerRadius(6)

                        Spacer()

                        if student.pendingAlerts > 0 {
                            Text("\(student.pendingAlerts) alerts")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 2)
                                .background(uniRed)
                                .cornerRadius(8)
                        }

                        Text(student.lastActive)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(14)

            // Quick actions
            HStack(spacing: 0) {
                quickAction(icon: "message.fill", label: "Message", color: uniRed)
                Divider().frame(height: 36)
                quickAction(icon: "calendar.badge.plus", label: "Schedule", color: .blue)
                Divider().frame(height: 36)
                quickAction(icon: "note.text.badge.plus", label: "Add note", color: .orange)
            }
            .background(Color(.systemGray6))
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 44))
                .foregroundColor(.green)
            Text("All clear! 🎉")
                .font(.system(size: 18, weight: .bold))
            Text("No students in this risk category")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }

    // MARK: - Helpers
    private func riskColor(_ risk: RiskLevel) -> Color {
        switch risk {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }

    private func trendColor(_ trend: Trend) -> Color {
        switch trend {
        case .rising: return .green
        case .stable: return .orange
        case .declining: return .red
        }
    }

    private func actionRow(icon: String, color: Color, text: String, sub: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.1))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.system(size: 14, weight: .semibold))
                Text(sub)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.secondary.opacity(0.4))
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
    }

    private func quickAction(icon: String, label: String, color: Color) -> some View {
        Button(action: {}) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
    }
}

// MARK: - Mini Sparkline
struct MiniSparkline: View {
    let grades: [Double]
    let color: Color

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let minG = grades.min() ?? 0
                let maxG = grades.max() ?? 10
                let range = maxG - minG == 0 ? 1 : maxG - minG
                let w = geo.size.width / CGFloat(grades.count - 1)
                for (i, g) in grades.enumerated() {
                    let x = CGFloat(i) * w
                    let y = geo.size.height * (1 - CGFloat((g - minG) / range))
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
        }
    }
}

// MARK: - Student Detail
struct StudentDetailView: View {
    let student: AdminStudent
    @Environment(\.dismiss) var dismiss
    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    // Header
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(riskColor.opacity(0.12))
                                .frame(width: 70, height: 70)
                            Text(student.name.components(separatedBy: " ").compactMap { $0.first }.prefix(2).map(String.init).joined())
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(riskColor)
                        }
                        Text(student.name)
                            .font(.system(size: 20, weight: .bold))
                        Text("\(student.program) · Year \(student.year)")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)

                    // Stats
                    HStack(spacing: 12) {
                        detailStat(value: String(format: "%.1f", student.gpa), label: "GPA", color: uniRed)
                        detailStat(value: "\(Int(student.attendance))%", label: "Attendance", color: .green)
                        detailStat(value: student.riskLevel.rawValue, label: "Risk", color: riskColor)
                        detailStat(value: student.trend.rawValue, label: "Trend", color: trendColor)
                    }
                    .padding(.horizontal, 16)

                    // AI Recommendation
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(uniRed)
                            Text("AI Recommendation")
                                .font(.system(size: 15, weight: .bold))
                        }
                        Text(recommendation)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                    }
                    .padding(16)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(.horizontal, 16)

                    // Quick Actions
                    HStack(spacing: 12) {
                        actionBtn(icon: "message.fill", label: "Message", color: uniRed)
                        actionBtn(icon: "calendar.badge.plus", label: "Schedule", color: .blue)
                        actionBtn(icon: "note.text.badge.plus", label: "Note", color: .orange)
                    }
                    .padding(.horizontal, 16)

                    if student.pendingAlerts > 0 {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(student.pendingAlerts) Active Alerts")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Immediate intervention recommended")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(14)
                        .background(Color.red.opacity(0.06))
                        .cornerRadius(14)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Student Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(uniRed)
                }
            }
        }
    }

    private var riskColor: Color {
        switch student.riskLevel {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }

    private var trendColor: Color {
        switch student.trend {
        case .rising: return .green
        case .stable: return .gray
        case .declining: return .red
        }
    }

    private var recommendation: String {
        switch student.riskLevel {
        case .high: return "⚠️ This student is at high risk. Attendance is critically low and GPA is declining. Immediate intervention recommended — schedule a meeting and notify the academic advisor."
        case .medium: return "⚡ This student shows moderate risk. Monitor closely over the next 2 weeks. Consider sending a motivational message or recommending tutoring sessions."
        case .low: return "✅ This student is performing well. No immediate action needed. Continue monitoring and provide positive reinforcement."
        }
    }

    private func detailStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.08))
        .cornerRadius(12)
    }

    private func actionBtn(icon: String, label: String, color: Color) -> some View {
        Button(action: {}) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color.opacity(0.08))
            .cornerRadius(14)
        }
    }
}
