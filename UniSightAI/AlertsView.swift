import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let category: String
    let courseCode: String
    let title: String
    let message: String
    let actionLabel: String
    let secondaryLabel: String?
    let categoryColor: Color
    var isRead: Bool = false
}

struct AlertsView: View {
    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)

    @State private var alerts: [AlertItem] = [
        AlertItem(
            category: "CRITICAL RISK",
            courseCode: "MATH 201",
            title: "Linear Algebra grade warning",
            message: "Predicted grade dropped to 7 in 3 weeks. Schedule office hours this week.",
            actionLabel: "Review plan",
            secondaryLabel: "Dismiss",
            categoryColor: Color(red: 0.80, green: 0.0, blue: 0.0)
        ),
        AlertItem(
            category: "ACTION NEEDED",
            courseCode: "CS 301",
            title: "Attendance threshold",
            message: "Algorithms attendance dropped to 67%. You are 3 sessions away from losing exam eligibility.",
            actionLabel: "Contact faculty",
            secondaryLabel: "Dismiss",
            categoryColor: .orange
        ),
        AlertItem(
            category: "OVERDUE",
            courseCode: "CS 302",
            title: "Database Systems · Lab 04 overdue",
            message: "Due 2 days ago. Submitting now keeps the estimated grade impact to -0.5.",
            actionLabel: "Submit now",
            secondaryLabel: "Request extension",
            categoryColor: Color(red: 0.80, green: 0.0, blue: 0.0)
        ),
        AlertItem(
            category: "STUDY TIP",
            courseCode: "AI Research",
            title: "Optimised preparation",
            message: "A 25-min Linear Algebra block today lifts your predicted GPA by +0.3.",
            actionLabel: "Start study sprint",
            secondaryLabel: nil,
            categoryColor: .blue,
            isRead: true
        ),
        AlertItem(
            category: "SUCCESS",
            courseCode: "CS 201",
            title: "Risk level improved",
            message: "Your risk level dropped from Medium to Low based on recent performance. Keep it up!",
            actionLabel: "View details",
            secondaryLabel: nil,
            categoryColor: .green,
            isRead: true
        ),
        AlertItem(
            category: "INFO",
            courseCode: "UniSight AI",
            title: "Weekly report ready",
            message: "Your weekly academic performance report is ready. Overall trend is positive.",
            actionLabel: "View report",
            secondaryLabel: "Dismiss",
            categoryColor: .purple,
            isRead: true
        )
    ]

    private var unreadCount: Int { alerts.filter { !$0.isRead }.count }
    private var gpaImpact: Double { 0.35 }

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: - Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Academic alerts")
                                .font(.system(size: 28, weight: .bold))
                            Text("UniSight AI assistant")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {}) {
                            ZStack {
                                Circle()
                                    .fill(uniRed.opacity(0.1))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(uniRed)
                                if unreadCount > 0 {
                                    Circle()
                                        .fill(uniRed)
                                        .frame(width: 14, height: 14)
                                        .overlay(
                                            Text("\(unreadCount)")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                        .offset(x: 14, y: -14)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 16)

                    // MARK: - Impact Banner
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 38, height: 38)
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("INTERVENTION IMPACT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                                .tracking(1)
                            Text("Resolving these alerts could lift your GPA by +\(String(format: "%.2f", gpaImpact))")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(colors: [uniRed, Color(red: 1.0, green: 0.2, blue: 0.2)], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    // MARK: - Alert Cards
                    VStack(spacing: 12) {
                        ForEach(alerts) { alert in
                            alertCard(alert: alert)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }

    // MARK: - Alert Card
    private func alertCard(alert: AlertItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Left border accent
            HStack(spacing: 0) {
                Rectangle()
                    .fill(alert.categoryColor)
                    .frame(width: 4)
                    .cornerRadius(2)

                VStack(alignment: .leading, spacing: 10) {
                    // Category + Course
                    HStack(spacing: 8) {
                        Text(alert.category)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(alert.categoryColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(alert.categoryColor.opacity(0.1))
                            .cornerRadius(6)

                        Text(alert.courseCode)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    // Title + Message
                    VStack(alignment: .leading, spacing: 4) {
                        Text(alert.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.primary)
                        Text(alert.message)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Action buttons
                    HStack(spacing: 10) {
                        Button(action: {}) {
                            Text(alert.actionLabel)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(alert.categoryColor)
                                .cornerRadius(12)
                        }

                        if let secondary = alert.secondaryLabel {
                            Button(action: {}) {
                                Text(secondary)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(alert.isRead ? 0.03 : 0.07), radius: 8, x: 0, y: 3)
        .opacity(alert.isRead ? 0.85 : 1.0)
    }
}

struct AlertsView_Previews: PreviewProvider {
    static var previews: some View {
        AlertsView()
    }
}
