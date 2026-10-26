//
//  Student.swift
//  UniSightAI
//
//  Created by Anila on 29.5.2026.
//

import Foundation

struct Student {
    let name: String
    let faculty: String
    let year: Int
    let semester: String
    let currentAverage: Double
    let predictedGrade: Double
    let lastSemesterAverage: Double
    let riskLevel: RiskLevel
    let trend: Trend
    let focusSubject: String
    let attendance: Double
    let pendingAssignments: Int
    let engagement: EngagementLevel
    let weeklyPerformance: [Double]
    let rank: Int
    let totalStudents: Int
    let semesterWeek: Int
    let totalWeeks: Int
    let semesterStart: String
    let semesterEnd: String
    let engagementChange: Double
    let attendanceChange: Double
}

enum RiskLevel: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum Trend: String {
    case rising = "Rising"
    case stable = "Stable"
    case declining = "Declining"
}

enum EngagementLevel: String {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

extension Student {
    static let sample = Student(
        name: "Anila Hajdini",
        faculty: "Faculty of Computer Science",
        year: 3,
        semester: "Spring 2026",
        currentAverage: 8.4,
        predictedGrade: 8.7,
        lastSemesterAverage: 8.1,
        riskLevel: .low,
        trend: .rising,
        focusSubject: "Algebra",
        attendance: 94,
        pendingAssignments: 2,
        engagement: .high,
        weeklyPerformance: [8.1, 8.9, 8.5, 9.3, 9.6, 7.8, 8.7],
        rank: 7,
        totalStudents: 142,
        semesterWeek: 9,
        totalWeeks: 15,
        semesterStart: "Feb 10",
        semesterEnd: "Jun 14",
        engagementChange: 8.0,
        attendanceChange: 2.1
    )
}
