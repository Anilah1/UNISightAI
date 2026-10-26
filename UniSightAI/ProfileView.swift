import SwiftUI

struct ProfileView: View {
    let student: Student
    @Binding var isLoggedIn: Bool
    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)

    // Llogaritjet e sakta nga GradesView
    private let totalECTS = 103        // ECTS të fituara (passed)
    private let totalRequired = 180    // ECTS totale për diplomim
    private let overallAvg = 8.6       // Mesatarja e të gjitha lëndëve të kaluara
    private let currentAvg = 8.4       // Mesatarja e semestrit aktual
    private let predictedGPA = 8.7     // Parashikimi i CoreML

    private var progressPct: Double { Double(totalECTS) / Double(totalRequired) }

    var body: some View {
        ZStack(alignment: .top) {
            uniRed.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Hero Header
                    heroHeader
                        .padding(.top, 60)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // MARK: - Stats Row
                    statsRow
                        .padding(.horizontal, 20)
                        .padding(.bottom, 36)

                    // MARK: - White Content
                    VStack(spacing: 0) {

                        // Degree Progress
                        degreeProgressSection
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            .padding(.bottom, 20)

                        Divider().padding(.horizontal, 20)

                        // Academic History
                        academicHistorySection
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 20)

                        Divider().padding(.horizontal, 20)

                        // Achievements
                        achievementsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 20)

                        Divider().padding(.horizontal, 20)

                        // Settings
                        settingsSection
                            .padding(.bottom, 8)

                        Divider().padding(.horizontal, 20)

                        // Logout
                        Button(action: { isLoggedIn = false }) {
                            HStack(spacing: 8) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Sign out")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(uniRed)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                    .background(Color(.systemGroupedBackground))
                    .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                }
            }
        }
    }

    // MARK: - Hero Header
    // MARK: - Hero Header
    private var heroHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 72, height: 72)
                    Text(initials)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(student.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    Text("Computer Science · Year \(student.year) · ID 232469725")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.75))

                    HStack(spacing: 8) {
                        badge(text: "Dean's List")
                        badge(text: "AI Lab")
                    }
                }
            }
        }
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(label: "GPA", value: String(format: "%.1f", currentAvg))
            statCard(label: "ECTS", value: "\(totalECTS)")
            statCard(label: "STREAK", value: "22d")
        }
    }
    // MARK: - Degree Progress
    private var degreeProgressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("DEGREE PROGRESS")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(1.5)
                    Text("B.Sc. Computer Science")
                        .font(.system(size: 17, weight: .bold))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    Text("\(Int(progressPct * 100))%")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(uniRed)
                    Text("\(totalECTS) / \(totalRequired) ECTS")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 10)
                    Capsule()
                        .fill(LinearGradient(colors: [uniRed, Color(red: 1.0, green: 0.3, blue: 0.3)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * progressPct, height: 10)
                }
            }
            .frame(height: 10)

            HStack {
                Text("Started Sept 2023")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Spacer()
                Text("Expected June 2026")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Academic History
    private var academicHistorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Academic history")
                .font(.system(size: 17, weight: .bold))

            VStack(spacing: 0) {
                historyRow(semester: "Spring 2026", detail: "predicted · in progress", grade: predictedGPA, ects: nil, isPredicted: true)
                Divider().padding(.leading, 44)
                historyRow(semester: "Fall 2025", detail: "30 ECTS · completed", grade: 8.6, ects: 30, isPredicted: false)
                Divider().padding(.leading, 44)
                historyRow(semester: "Spring 2025", detail: "29 ECTS · completed", grade: 8.4, ects: 29, isPredicted: false)
                Divider().padding(.leading, 44)
                historyRow(semester: "Fall 2024", detail: "26 ECTS · completed", grade: 8.8, ects: 26, isPredicted: false)
                Divider().padding(.leading, 44)
                historyRow(semester: "Spring 2024", detail: "18 ECTS · completed", grade: 8.4, ects: 18, isPredicted: false)
            }
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    // MARK: - Achievements
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Achievements")
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                Text("3 EARNED")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(uniRed)
                    .tracking(1)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    achievementCard(icon: "trophy.fill", title: "Top 5%", sub: "Spring 2025", color: uniRed)
                    achievementCard(icon: "flame.fill", title: "Perfect Week", sub: "7 day streak", color: .orange)
                    achievementCard(icon: "star.fill", title: "AI Scholar", sub: "Research track", color: .purple)
                    achievementCard(icon: "person.2.fill", title: "Coordinator", sub: "Staff role", color: .blue)
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Settings
    private var settingsSection: some View {
        VStack(spacing: 0) {
            settingRow(icon: "brain.head.profile", iconColor: uniRed, title: "AI Study assistant", sub: "Personalised recommendations")
            Divider().padding(.leading, 56)
            settingRow(icon: "lock.shield.fill", iconColor: .blue, title: "Security & sign-in", sub: "Face ID · 2FA")
            Divider().padding(.leading, 56)
            settingRow(icon: "person.crop.circle.badge.checkmark", iconColor: .green, title: "Account & role", sub: "Student · Coordinator")
            Divider().padding(.leading, 56)
            settingRow(icon: "bell.fill", iconColor: .orange, title: "Notifications", sub: "Alerts and reminders")
        }
        .padding(.top, 8)
    }

    // MARK: - Helpers
    private var initials: String {
        student.name.components(separatedBy: " ").compactMap { $0.first }.prefix(2).map(String.init).joined()
    }
    
    private func badge(text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(uniRed)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.white)
            .cornerRadius(20)
    }

    private func statCard(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
            Text(value)
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
    }

  

    private func historyRow(semester: String, detail: String, grade: Double, ects: Int?, isPredicted: Bool) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(uniRed.opacity(0.1))
                    .frame(width: 32, height: 32)
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 13))
                    .foregroundColor(uniRed)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(semester)
                    .font(.system(size: 14, weight: .semibold))
                Text(detail)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(String(format: "%.1f", grade))
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundColor(isPredicted ? .secondary : uniRed)
                Text("/10")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private func achievementCard(icon: String, title: String, sub: String, color: Color) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                Text(sub)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 110)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private func settingRow(icon: String, iconColor: Color, title: String, sub: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                Text(sub)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(.secondary.opacity(0.4))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(student: .sample, isLoggedIn: .constant(true))
    }
}
