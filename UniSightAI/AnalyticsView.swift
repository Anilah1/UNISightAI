import SwiftUI

struct AnalyticsView: View {
    let student: Student
    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)
    @State private var selectedPeriod = 0
    @State private var animateBars = false
    let periods = ["Week", "Month", "Semester"]

    var body: some View {
        ZStack(alignment: .top) {
            uniRed.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerBar
                    statsRow
                        .padding(.bottom, 36)

                    VStack(spacing: 16) {
                        periodPicker
                        gradeTrendCard
                        subjectPerformanceCard
                        attendanceCard
                        summaryCard
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateBars = true
            }
        }
    }

    // MARK: - Header
    private var headerBar: some View {
        HStack {
            Spacer()
            Text("Analytics")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.top, 60)
        .padding(.bottom, 16)
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 0) {
            heroPill(icon: "chart.line.uptrend.xyaxis", value: "8", label: "GPA")
            Rectangle().fill(Color.white.opacity(0.25)).frame(width: 1, height: 36)
            heroPill(icon: "person.fill.checkmark", value: "94%", label: "Attendance")
            Rectangle().fill(Color.white.opacity(0.25)).frame(width: 1, height: 36)
            heroPill(icon: "star.fill", value: "#7", label: "Rank")
            Rectangle().fill(Color.white.opacity(0.25)).frame(width: 1, height: 36)
            heroPill(icon: "bolt.fill", value: "High", label: "Engage")
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Period Picker
    private var periodPicker: some View {
        HStack(spacing: 0) {
            ForEach(0..<periods.count, id: \.self) { i in
                Button(action: { selectedPeriod = i }) {
                    Text(periods[i])
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedPeriod == i ? .white : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedPeriod == i ? uniRed : Color.clear)
                        .cornerRadius(12)
                }
            }
        }
        .padding(4)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }

    // MARK: - Grade Trend
    private var gradeTrendCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader(icon: "chart.line.uptrend.xyaxis", iconColor: uniRed, title: "Grade Trend", subtitle: "Semester overview")

            GeometryReader { geo in
                ZStack {
                    gridLines(geo: geo)
                    gradientFill(geo: geo)
                    avgLine(geo: geo)
                    myGradeLine(geo: geo)
                    dotsLayer(geo: geo)
                }
            }
            .frame(height: 130)
            .padding(.leading, 20)

            HStack(spacing: 16) {
                legendItem(color: uniRed, label: "Your grade")
                legendItem(color: .gray.opacity(0.5), label: "Class average")
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    // MARK: - Subject Performance
    private var subjectPerformanceCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader(icon: "book.closed.fill", iconColor: .blue, title: "Subject Performance", subtitle: "Current semester")
            VStack(spacing: 12) {
                ForEach(Array(subjects.enumerated()), id: \.0) { index, subject in
                    subjectRow(name: subject.0, grade: subject.1, color: subject.2, index: index)
                }
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    // MARK: - Attendance
    private var attendanceCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader(icon: "calendar.badge.checkmark", iconColor: .green, title: "Attendance", subtitle: "Last 4 weeks")

            HStack(spacing: 0) {
                Text("").frame(width: 28)
                ForEach(["M","T","W","T","F"], id: \.self) { d in
                    Text(d)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            ForEach(0..<attendanceData.count, id: \.self) { w in
                HStack(spacing: 0) {
                    Text("W\(w+1)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                        .frame(width: 28)
                    ForEach(0..<attendanceData[w].count, id: \.self) { d in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(cellColor(attendanceData[w][d]))
                            .frame(height: 32)
                            .padding(3)
                            .frame(maxWidth: .infinity)
                    }
                }
            }

            HStack(spacing: 16) {
                legendItem(color: uniRed.opacity(0.8), label: "Present")
                legendItem(color: .orange.opacity(0.6), label: "Late")
                legendItem(color: Color(.systemGray4), label: "Absent")
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    // MARK: - Summary
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader(icon: "chart.bar.doc.horizontal", iconColor: .purple, title: "Summary Stats", subtitle: "This semester")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                summaryBox(value: "94%", label: "Attendance", color: .green, icon: "person.fill.checkmark")
                summaryBox(value: "8", label: "Current GPA", color: uniRed, icon: "star.fill")
                summaryBox(value: "88%", label: "Assignments", color: .blue, icon: "doc.text.fill")
                summaryBox(value: "#7", label: "Class Rank", color: .purple, icon: "trophy.fill")
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    // MARK: - Data
    private var semesterGrades: [Double] { [7, 7, 8, 8, 8, 8, 9, 8, 8] }
    private var classAvgData: [Double] { [7, 7, 7, 8, 7, 8, 7, 8, 7] }

    private var subjects: [(String, Int, Color)] {
        [
            ("Algorithms", 9, .green),
            ("Database Systems", 8, .blue),
            ("Software Engineering", 8, uniRed),
            ("Linear Algebra", 7, .orange),
            ("Computer Networks", 9, .purple)
        ]
    }

    private var attendanceData: [[Int]] {
        [[1,1,1,1,1],[1,0,1,1,1],[1,1,2,1,1],[1,1,1,0,1]]
    }

    // MARK: - Chart Helpers
    private func xPoint(_ i: Int, width: CGFloat) -> CGFloat {
        width * CGFloat(i) / CGFloat(semesterGrades.count - 1)
    }

    private func yPoint(_ val: Double, height: CGFloat) -> CGFloat {
        let minV = 5.0, maxV = 10.0
        return height * (1 - CGFloat((val - minV) / (maxV - minV)))
    }

    private func gridLines(geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            ForEach([10, 9, 8, 7, 6], id: \.self) { val in
                HStack(spacing: 4) {
                    Text("\(val)")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                        .frame(width: 14, alignment: .trailing)
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 0.5)
                }
                if val != 6 { Spacer() }
            }
        }
        .frame(height: geo.size.height)
    }

    private func myGradeLine(geo: GeometryProxy) -> some View {
        Path { path in
            for i in 0..<semesterGrades.count {
                let x = xPoint(i, width: geo.size.width)
                let y = yPoint(semesterGrades[i], height: geo.size.height)
                if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
        }
        .stroke(uniRed, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }

    private func avgLine(geo: GeometryProxy) -> some View {
        Path { path in
            for i in 0..<classAvgData.count {
                let x = xPoint(i, width: geo.size.width)
                let y = yPoint(classAvgData[i], height: geo.size.height)
                if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                else { path.addLine(to: CGPoint(x: x, y: y)) }
            }
        }
        .stroke(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
    }

    private func gradientFill(geo: GeometryProxy) -> some View {
        Path { path in
            for i in 0..<semesterGrades.count {
                let x = xPoint(i, width: geo.size.width)
                let y = yPoint(semesterGrades[i], height: geo.size.height)
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: geo.size.height))
                    path.addLine(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
            path.closeSubpath()
        }
        .fill(LinearGradient(colors: [uniRed.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
    }

    private func dotsLayer(geo: GeometryProxy) -> some View {
        ForEach(0..<semesterGrades.count, id: \.self) { i in
            Circle()
                .fill(uniRed)
                .frame(width: 7, height: 7)
                .position(x: xPoint(i, width: geo.size.width), y: yPoint(semesterGrades[i], height: geo.size.height))
        }
    }

    // MARK: - Helper Views
    private func cardHeader(icon: String, iconColor: Color, title: String, subtitle: String) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(iconColor)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
    }

    private func heroPill(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity)
    }

    private func subjectRow(name: String, grade: Int, color: Color, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(color).frame(width: 8, height: 8)
                    Text(name).font(.system(size: 13, weight: .medium))
                }
                Spacer()
                Text("\(grade)/10")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5)).frame(height: 7)
                    Capsule()
                        .fill(LinearGradient(colors: [color, color.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: animateBars ? geo.size.width * CGFloat(grade) / 10.0 : 0, height: 7)
                        .animation(.easeInOut(duration: 0.7).delay(Double(index) * 0.1), value: animateBars)
                }
            }
            .frame(height: 7)
        }
    }

    private func summaryBox(value: String, label: String, color: Color, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 18)).foregroundColor(color)
            Text(value).font(.system(size: 22, weight: .heavy, design: .rounded)).foregroundColor(color)
            Text(label).font(.system(size: 11)).foregroundColor(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.08))
        .cornerRadius(14)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 14, height: 8)
            Text(label).font(.system(size: 11)).foregroundColor(.secondary)
        }
    }

    private func cellColor(_ val: Int) -> Color {
        switch val {
        case 0: return Color(.systemGray4)
        case 2: return .orange.opacity(0.6)
        default: return uniRed.opacity(0.8)
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(student: .sample)
    }
}
