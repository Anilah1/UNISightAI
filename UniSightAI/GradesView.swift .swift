import SwiftUI

struct Course: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let ects: Int
    let grade: Int
    let semester: String
    let status: CourseStatus
}

enum CourseStatus {
    case passed, inProgress, failed

    var label: String {
        switch self {
        case .passed: return "Completed"
        case .inProgress: return "In Progress"
        case .failed: return "Failed"
        }
    }

    var color: Color {
        switch self {
        case .passed: return .green
        case .inProgress: return .blue
        case .failed: return .red
        }
    }
}

struct GradesView: View {
    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)

    let courses: [Course] = [
        // Spring 2026 - current (5 lëndë × mesatare = 8.2)
        Course(name: "Algorithms & Data Structures", code: "CS301", ects: 6, grade: 9, semester: "Spring 2026", status: .inProgress),
        Course(name: "Database Systems", code: "CS302", ects: 6, grade: 8, semester: "Spring 2026", status: .inProgress),
        Course(name: "Software Engineering", code: "CS303", ects: 5, grade: 8, semester: "Spring 2026", status: .inProgress),
        Course(name: "Linear Algebra", code: "MATH201", ects: 5, grade: 7, semester: "Spring 2026", status: .inProgress),
        Course(name: "Computer Networks", code: "CS304", ects: 6, grade: 9, semester: "Spring 2026", status: .inProgress),
        // Fall 2025 (5 lëndë × mesatare = 8.6)
        Course(name: "Object Oriented Programming", code: "CS201", ects: 6, grade: 10, semester: "Fall 2025", status: .passed),
        Course(name: "Calculus I", code: "MATH101", ects: 5, grade: 8, semester: "Fall 2025", status: .passed),
        Course(name: "Operating Systems", code: "CS202", ects: 6, grade: 9, semester: "Fall 2025", status: .passed),
        Course(name: "Statistics", code: "MATH202", ects: 5, grade: 8, semester: "Fall 2025", status: .passed),
        Course(name: "Computer Architecture", code: "CS203", ects: 6, grade: 8, semester: "Fall 2025", status: .passed),
        // Spring 2025
        Course(name: "Web Development", code: "CS204", ects: 5, grade: 8, semester: "Spring 2025", status: .passed),
        Course(name: "Discrete Mathematics", code: "MATH102", ects: 5, grade: 7, semester: "Spring 2025", status: .passed),
        Course(name: "Data Structures", code: "CS205", ects: 6, grade: 9, semester: "Spring 2025", status: .passed),
        Course(name: "Digital Logic", code: "CS206", ects: 5, grade: 9, semester: "Spring 2025", status: .passed),
        Course(name: "English for IT", code: "ENG101", ects: 4, grade: 9, semester: "Spring 2025", status: .passed),
        // Fall 2024
        Course(name: "Introduction to CS", code: "CS101", ects: 6, grade: 10, semester: "Fall 2024", status: .passed),
        Course(name: "Programming Fundamentals", code: "CS102", ects: 6, grade: 9, semester: "Fall 2024", status: .passed),
        Course(name: "Mathematics I", code: "MATH103", ects: 5, grade: 8, semester: "Fall 2024", status: .passed),
        Course(name: "Communication Skills", code: "GEN101", ects: 4, grade: 9, semester: "Fall 2024", status: .passed),
        Course(name: "Physics I", code: "PHY101", ects: 5, grade: 8, semester: "Fall 2024", status: .passed),
        // Spring 2024
        Course(name: "Programming II", code: "CS103", ects: 6, grade: 9, semester: "Spring 2024", status: .passed),
        Course(name: "Mathematics II", code: "MATH104", ects: 5, grade: 7, semester: "Spring 2024", status: .passed),
        Course(name: "Database Fundamentals", code: "CS104", ects: 5, grade: 9, semester: "Spring 2024", status: .passed),
        Course(name: "Professional Ethics", code: "GEN102", ects: 3, grade: 10, semester: "Spring 2024", status: .passed),
        Course(name: "Physics II", code: "PHY102", ects: 5, grade: 7, semester: "Spring 2024", status: .passed),
    ]

    @State private var selectedSemester = "All"
    let semesters = ["All", "Spring 2026", "Fall 2025", "Spring 2025", "Fall 2024", "Spring 2024"]

    private var filtered: [Course] {
        selectedSemester == "All" ? courses : courses.filter { $0.semester == selectedSemester }
    }

    // ECTS vetëm nga lëndët e kaluara
    private var totalECTS: Int {
        courses.filter { $0.status == .passed }.reduce(0) { $0 + $1.ects }
    }

    // Mesatarja e semestrit aktual (inProgress)
    private var currentAvg: Double {
        let current = courses.filter { $0.status == .inProgress }
        guard !current.isEmpty else { return 0 }
        return Double(current.reduce(0) { $0 + $1.grade }) / Double(current.count)
    }

    // Mesatarja e përgjithshme (të gjitha lëndët e kaluara)
    private var overallAvg: Double {
        let passed = courses.filter { $0.status == .passed }
        guard !passed.isEmpty else { return 0 }
        return Double(passed.reduce(0) { $0 + $1.grade }) / Double(passed.count)
    }

    private var passedCount: Int {
        courses.filter { $0.status == .passed }.count
    }

    var body: some View {
        ZStack(alignment: .top) {
            uniRed.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Header
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                            Text("GRADES")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                                .tracking(2)
                        }
                        Spacer()
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 20)

                    // MARK: - Stats Row
                    HStack(spacing: 0) {
                        heroPill(value: String(format: "%.1f", currentAvg), label: "Current Avg")
                        Rectangle().fill(Color.white.opacity(0.25)).frame(width: 1, height: 36)
                        heroPill(value: String(format: "%.1f", overallAvg), label: "Overall Avg")
                        Rectangle().fill(Color.white.opacity(0.25)).frame(width: 1, height: 36)
                        heroPill(value: "\(totalECTS)", label: "ECTS Earned")
                        Rectangle().fill(Color.white.opacity(0.25)).frame(width: 1, height: 36)
                        heroPill(value: "\(passedCount)", label: "Completed")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 36)

                    // MARK: - White content
                    VStack(spacing: 16) {

                        // Progress Card
                        progressCard

                        // Filter
                        semesterFilter

                        // Courses
                        VStack(spacing: 10) {
                            ForEach(filtered) { course in
                                courseCard(course: course)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(28, corners: [.topLeft, .topRight])
                }
            }
        }
    }

    // MARK: - Progress Card
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Academic Progress")
                        .font(.system(size: 15, weight: .bold))
                    Text("180 ECTS required for graduation")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("\(Int(Double(totalECTS) / 180.0 * 100))%")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(uniRed)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 10)
                    Capsule()
                        .fill(LinearGradient(
                            colors: [uniRed, Color(red: 1.0, green: 0.3, blue: 0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: geo.size.width * CGFloat(totalECTS) / 180.0, height: 10)
                }
            }
            .frame(height: 10)

            HStack {
                Label("\(totalECTS) ECTS earned", systemImage: "checkmark.circle.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.green)
                Spacer()
                Label("\(180 - totalECTS) remaining", systemImage: "clock.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    // MARK: - Filter
    private var semesterFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(semesters, id: \.self) { sem in
                    Button(action: { selectedSemester = sem }) {
                        Text(sem)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(selectedSemester == sem ? .white : .primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedSemester == sem ? uniRed : Color(.systemBackground))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Course Card
    private func courseCard(course: Course) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(gradeColor(course.grade).opacity(0.12))
                    .frame(width: 52, height: 52)
                Text("\(course.grade)")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(gradeColor(course.grade))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(course.name)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(course.code)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text("·")
                        .foregroundColor(.secondary)
                    Text("\(course.ects) ECTS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(uniRed)
                    Text("·")
                        .foregroundColor(.secondary)
                    Text(course.semester)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Text(course.status.label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(course.status.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(course.status.color.opacity(0.1))
                    .cornerRadius(6)
            }

            Spacer()

            VStack(spacing: 1) {
                Text("\(course.grade)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(gradeColor(course.grade))
                Text("/10")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private func heroPill(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func gradeColor(_ grade: Int) -> Color {
        switch grade {
        case 10: return Color(red: 0.0, green: 0.6, blue: 0.3)
        case 9: return .green
        case 8: return .blue
        case 7: return .orange
        case 6: return Color(red: 1.0, green: 0.5, blue: 0.0)
        default: return .red
        }
    }
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}
