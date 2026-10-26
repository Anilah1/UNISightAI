import SwiftUI

struct HomeView: View {
    let student: Student
    @State private var animateRing = false
    @State private var animateBars = false
    @State private var selectedDay = 4
    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)

    private var gradeChange: Double {
        student.currentAverage - student.lastSemesterAverage
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {

                // MARK: - Header
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 60)

                // MARK: - Main Card
                mainCard
                    .padding(.horizontal, 20)

                // MARK: - Stats Row
                statsRow
                    .padding(.horizontal, 20)

                // MARK: - Semester Progress
                semesterCard
                    .padding(.horizontal, 20)

                // MARK: - Weekly Performance
                weeklyCard
                    .padding(.horizontal, 20)

                // MARK: - Why this prediction
                xaiCard
                    .padding(.horizontal, 20)

                // MARK: - Study Recommendations
                recommendationsCard
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) { animateRing = true }
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) { animateBars = true }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(greetingText)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text(student.name)
                    .font(.system(size: 28, weight: .bold))
                Text("\(student.faculty) · Year \(student.year)")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(uniRed.opacity(0.12))
                    .frame(width: 48, height: 48)
                Text(initials)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(uniRed)
                Circle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                    .offset(x: 17, y: 17)
            }
        }
    }

    // MARK: - Main Card
    private var mainCard: some View {
        VStack(spacing: 0) {
            // Red top
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("SEMESTER · \(student.semester.uppercased())")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(1)
                    Spacer()
                }

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Current average")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.75))
                        Text(String(format: "%.1f", student.currentAverage))
                            .font(.system(size: 52, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 11, weight: .bold))
                            Text(String(format: "+%.1f vs last semester", gradeChange))
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                    }
                    Spacer()
                    // Ring
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 8)
                            .frame(width: 90, height: 90)
                        Circle()
                            .trim(from: 0, to: animateRing ? CGFloat(student.predictedGrade / 10.0) : 0)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 90, height: 90)
                            .rotationEffect(.degrees(-90))
                        VStack(spacing: 0) {
                            Text("PREDICTED")
                                .font(.system(size: 7, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                                .tracking(0.5)
                            Text(String(format: "%.1f", student.predictedGrade))
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                            Text("of 10.0")
                                .font(.system(size: 9))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
            }
            .padding(20)
            .background(
                LinearGradient(colors: [Color(red: 0.65, green: 0.0, blue: 0.0), uniRed], startPoint: .topLeading, endPoint: .bottomTrailing)
            )

            // Risk badges
            HStack(spacing: 0) {
                riskBadge(label: "RISK", value: student.riskLevel.rawValue, color: riskColor)
                Divider().frame(height: 40)
                riskBadge(label: "TREND", value: student.trend.rawValue, color: trendColor)
                Divider().frame(height: 40)
                riskBadge(label: "FOCUS", value: student.focusSubject, color: .primary)
            }
            .background(Color(.systemBackground))
        }
        .cornerRadius(20)
        .shadow(color: uniRed.opacity(0.2), radius: 14, x: 0, y: 6)
        .clipped()
    }

    private var statsRow: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                statMiniCard(icon: "calendar.badge.checkmark", iconColor: uniRed, label: "ATTENDANCE", value: "\(Int(student.attendance))%", sub: "+\(String(format: "%.1f", student.attendanceChange))%", subColor: .green, showLine: true)
                statMiniCard(icon: "doc.text.fill", iconColor: .orange, label: "ASSIGNMENTS", value: "22 / 24", sub: "2 pending", subColor: .orange, showLine: true)
            }
            HStack(spacing: 12) {
                statMiniCard(icon: "waveform.path.ecg", iconColor: uniRed, label: "ENGAGEMENT", value: student.engagement.rawValue, sub: "+\(Int(student.engagementChange))% wk", subColor: .green, showLine: true)
                statMiniCard(icon: "graduationcap.fill", iconColor: uniRed, label: "RANK", value: "#\(student.rank)", sub: "of \(student.totalStudents)", subColor: .secondary, showLine: false)
            }
        }
    }

    // MARK: - Semester Card
    private var semesterCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Semester progress")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                Text("Week \(student.semesterWeek) of \(student.totalWeeks)")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5)).frame(height: 8)
                    Capsule()
                        .fill(LinearGradient(colors: [uniRed, Color(red: 1.0, green: 0.3, blue: 0.3)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * CGFloat(student.semesterWeek) / CGFloat(student.totalWeeks), height: 8)
                }
            }
            .frame(height: 8)
            HStack {
                Text("Started · \(student.semesterStart)")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(Double(student.semesterWeek)/Double(student.totalWeeks)*100))% complete")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(uniRed)
                Spacer()
                Text("Ends · \(student.semesterEnd)")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Weekly Card
    private var weeklyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Weekly performance")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 2) {
                        Text("Details")
                            .font(.system(size: 13, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(uniRed)
                }
            }

            HStack(alignment: .bottom, spacing: 6) {
                ForEach(0..<student.weeklyPerformance.count, id: \.self) { i in
                    let val = student.weeklyPerformance[i]
                    let days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                    let isSelected = i == selectedDay
                    VStack(spacing: 4) {
                        Text(String(format: "%.1f", val))
                            .font(.system(size: 9, weight: isSelected ? .bold : .regular))
                            .foregroundColor(isSelected ? uniRed : .secondary)
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray6))
                                .frame(height: 80)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(isSelected ? uniRed : uniRed.opacity(0.2))
                                .frame(height: animateBars ? CGFloat(val / 10.0) * 80 : 0)
                                .animation(.spring(response: 0.5).delay(Double(i) * 0.05), value: animateBars)
                        }
                        Text(days[i])
                            .font(.system(size: 9, weight: isSelected ? .bold : .regular))
                            .foregroundColor(isSelected ? uniRed : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture { withAnimation { selectedDay = i } }
                }
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - XAI Card
    private var xaiCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Why this prediction?")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 2) {
                        Text("Explainable AI")
                            .font(.system(size: 13, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(uniRed)
                }
            }

            Text("Top contributing factors · 87% confidence")
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            VStack(spacing: 10) {
                xaiRow(label: "Quiz consistency", value: 0.86, color: .primary)
                xaiRow(label: "Attendance streak", value: 0.74, color: .primary)
                xaiRow(label: "Late submissions", value: 0.28, color: uniRed)
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Recommendations
    private var recommendationsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Study recommendations")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 2) {
                        Text("More")
                            .font(.system(size: 13, weight: .medium))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(uniRed)
                }
            }

            VStack(spacing: 0) {
                recommendRow(icon: "lightbulb.fill", iconColor: uniRed.opacity(0.8), title: "Review Linear Algebra · 25 min", sub: "Lift predicted grade to 9", isOverdue: false)
                Divider().padding(.leading, 52)
                recommendRow(icon: "lightbulb.fill", iconColor: uniRed, title: "Submit Database Systems Lab 04", sub: "Overdue by 2 days", isOverdue: true)
                Divider().padding(.leading, 52)
                recommendRow(icon: "lightbulb.fill", iconColor: .secondary.opacity(0.6), title: "Read Data Ethics ch. 4", sub: "Quiz on Friday", isOverdue: false)
                Divider().padding(.leading, 52)
                recommendRow(icon: "bell.fill", iconColor: uniRed.opacity(0.8), title: "3 new academic alerts", sub: "Review attendance and assignment updates", isOverdue: false)
            }
            .background(Color(.systemBackground))
            .cornerRadius(14)
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Helpers
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning" }
        else if hour < 17 { return "Good afternoon" }
        else { return "Good evening" }
    }

    private var initials: String {
        student.name.components(separatedBy: " ").compactMap { $0.first }.prefix(2).map(String.init).joined()
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
        case .rising: return Color(red: 0.0, green: 0.5, blue: 0.9)
        case .stable: return .gray
        case .declining: return .red
        }
    }

    private func riskBadge(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    private func statMiniCard(icon: String, iconColor: Color, label: String, value: String, sub: String, subColor: Color, showLine: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(iconColor)
                    .frame(width: 30, height: 30)
                    .background(iconColor.opacity(0.1))
                    .cornerRadius(8)
                Spacer()
                Text(sub)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(subColor == .secondary ? .secondary : subColor)
            }
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            Text(value)
                .font(.system(size: 22, weight: .bold))

            if showLine {
                GeometryReader { geo in
                    Path { path in
                        let pts: [CGFloat] = [0.3, 0.4, 0.35, 0.5, 0.6, 0.55, 0.7, 0.75, 0.8]
                        let w = geo.size.width / CGFloat(pts.count - 1)
                        path.move(to: CGPoint(x: 0, y: geo.size.height * (1 - pts[0])))
                        for i in 1..<pts.count {
                            path.addLine(to: CGPoint(x: CGFloat(i) * w, y: geo.size.height * (1 - pts[i])))
                        }
                    }
                    .stroke(iconColor.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                }
                .frame(height: 28)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private func xaiRow(label: String, value: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5)).frame(height: 6)
                    Capsule()
                        .fill(color == uniRed ? uniRed : Color(.label))
                        .frame(width: geo.size.width * value, height: 6)
                }
            }
            .frame(height: 6)
        }
    }

    private func recommendRow(icon: String, iconColor: Color, title: String, sub: String, isOverdue: Bool) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                Text(sub)
                    .font(.system(size: 12))
                    .foregroundColor(isOverdue ? uniRed : .secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.secondary.opacity(0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Sparklines (needed by other views)
struct EngagementSparkline: View {
    let color: Color
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let points: [CGFloat] = [0.3, 0.35, 0.32, 0.45, 0.5, 0.55, 0.65, 0.72, 0.8]
                let w = geo.size.width / CGFloat(points.count - 1)
                path.move(to: CGPoint(x: 0, y: geo.size.height * (1 - points[0])))
                for i in 1..<points.count {
                    path.addLine(to: CGPoint(x: CGFloat(i) * w, y: geo.size.height * (1 - points[i])))
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
        .frame(height: 32)
    }
}

struct RankSparkline: View {
    let color: Color
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let points: [CGFloat] = [0.9, 0.82, 0.75, 0.68, 0.60, 0.52, 0.44, 0.38, 0.30]
                let w = geo.size.width / CGFloat(points.count - 1)
                path.move(to: CGPoint(x: 0, y: geo.size.height * (1 - points[0])))
                for i in 1..<points.count {
                    path.addLine(to: CGPoint(x: CGFloat(i) * w, y: geo.size.height * (1 - points[i])))
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
        .frame(height: 32)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(student: .sample)
    }
}
