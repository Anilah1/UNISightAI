import SwiftUI

struct InsightsView: View {
    let student: Student
    @State private var animateBars = false
    private let uniRed = Color(red: 0.80, green: 0.0, blue: 0.0)

    private var prediction: (riskLevel: RiskLevel, confidence: Double) {
        PredictionService.shared.predictForStudent(student)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("AI INSIGHTS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(2)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.secondary.opacity(0.3))
                        }
                    }
                    .padding(.top, 60)

                    HStack(spacing: 0) {
                        Text("Why a predicted ")
                            .font(.system(size: 28, weight: .bold))
                        Text(String(format: "%.1f", student.predictedGrade))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(uniRed)
                        Text("?")
                            .font(.system(size: 28, weight: .bold))
                    }
                    Text("Explainable factors behind the model's prediction.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                // MARK: - Confidence Banner
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 42, height: 42)
                        Image(systemName: "cpu.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("MODEL CONFIDENCE")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                            .tracking(1.5)
                        Text("Gradient Boosting · attention-based predictor")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(String(format: "%.0f%%", prediction.confidence * 100))
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(18)
                .background(uniRed)
                .padding(.horizontal, 20)
                .cornerRadius(16)
                .overlay(alignment: .bottom) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 4)
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: animateBars ? geo.size.width * prediction.confidence : 0, height: 4)
                                .animation(.easeInOut(duration: 1.2), value: animateBars)
                        }
                    }
                    .frame(height: 4)
                    .cornerRadius(2)
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 28)

                // MARK: - Contributing Factors
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Contributing factors")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Text("BY INFLUENCE")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.5)
                    }
                    .padding(.horizontal, 20)

                    Text("Ranked by influence on final grade")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.top, -12)

                    VStack(spacing: 0) {
                        ForEach(Array(factors.enumerated()), id: \.0) { index, factor in
                            factorRow(factor: factor, index: index)
                            if index < factors.count - 1 {
                                Divider().padding(.leading, 20)
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 28)

                // MARK: - Model Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(uniRed.opacity(0.1))
                                .frame(width: 44, height: 44)
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 20))
                                .foregroundColor(uniRed)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("UniSight AI v1.0")
                                .font(.system(size: 16, weight: .bold))
                            Text("MODEL CARD")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.5)
                        }
                    }

                    HStack(spacing: 0) {
                        modelStat(label: "DATASET", value: "500")
                        Divider().frame(height: 40)
                        modelStat(label: "ACCURACY", value: "97.1%")
                        Divider().frame(height: 40)
                        modelStat(label: "F1 SCORE", value: "0.97")
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    Text("A Gradient Boosting predictor trained on synthetic academic data. SHAP values surface every prediction for full auditability. Integrated via CoreML on-device.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineSpacing(3)

                    // Recommendations
                    VStack(spacing: 0) {
                        recRow(icon: "book.fill", color: uniRed, title: "Focus on Linear Algebra", sub: "Weakest subject — attend office hours", priority: "HIGH")
                        Divider().padding(.leading, 52)
                        recRow(icon: "clock.badge.exclamationmark.fill", color: .orange, title: "Submit pending assignments", sub: "2 overdue — submit ASAP", priority: "MED")
                        Divider().padding(.leading, 52)
                        recRow(icon: "person.2.fill", color: .green, title: "Keep engagement up", sub: "Top 25% in class — maintain it", priority: "LOW")
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(18)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
                animateBars = true
            }
        }
    }

    // MARK: - Data
    private var factors: [(String, String, Double, Bool, String)] {
        [
            ("Quiz consistency", "8 quizzes above class average", 0.86, false, "+86%"),
            ("Attendance streak", "22-day attendance streak", 0.74, false, "+74%"),
            ("Late submissions", "2 late · -0.2 grade impact", 0.28, true, "-28%"),
            ("Platform engagement", "Top 12% participation", 0.61, false, "+61%"),
            ("Credit progress", "72% of semester credits", 0.55, false, "+55%"),
        ]
    }

    // MARK: - Factor Row
    private func factorRow(factor: (String, String, Double, Bool, String), index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Rectangle()
                    .fill(factor.3 ? uniRed : Color(.systemGray3))
                    .frame(width: 3, height: 36)
                    .cornerRadius(2)
                    .padding(.leading, 4)

                VStack(alignment: .leading, spacing: 2) {
                    Text(factor.0)
                        .font(.system(size: 15, weight: .semibold))
                    Text(factor.1)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(factor.4)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(factor.3 ? uniRed : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray6))
                        .frame(height: 3)
                    Rectangle()
                        .fill(factor.3 ? uniRed : Color(.label))
                        .frame(width: animateBars ? geo.size.width * factor.2 : 0, height: 3)
                        .animation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1), value: animateBars)
                }
            }
            .frame(height: 3)
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
    }

    private func modelStat(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    private func recRow(icon: String, color: Color, title: String, sub: String, priority: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                Text(sub)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(priority)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(color)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(color.opacity(0.1))
                .cornerRadius(6)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(student: .sample)
    }
}
