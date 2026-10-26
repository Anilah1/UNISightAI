//
//  PredictionService.swift
//  UniSightAI
//
//  Created by Anila on 31.5.2026.
//

import Foundation
import CoreML

class PredictionService {
    static let shared = PredictionService()

    private init() {}

    // Scaler params nga training
    private let mean = [0.8198, 0.7988, 0.7492, 0.7198, 7.502, 7.612]
    private let scale = [0.1198, 0.1502, 0.1798, 0.1998, 1.498, 1.312]

    func predictForStudent(_ student: Student) -> (riskLevel: RiskLevel, confidence: Double) {
        let attendance = student.attendance / 100.0
        let assignments = 0.88
        let engagement = 0.80
        let credits = Double(student.semesterWeek) / Double(student.totalWeeks)
        let prevGPA = student.lastSemesterAverage
        let currGPA = student.currentAverage

        // Score bazuar në tregues
        let score = attendance * 0.30 +
                    assignments * 0.30 +
                    engagement * 0.20 +
                    (currGPA / 10.0) * 0.20

        let riskLevel: RiskLevel
        let confidence: Double

        if score >= 0.78 {
            riskLevel = .low
            confidence = min(0.95, score)
        } else if score >= 0.58 {
            riskLevel = .medium
            confidence = 0.75
        } else {
            riskLevel = .high
            confidence = min(0.95, 1.0 - score)
        }

        return (riskLevel, confidence)
    }

    func getRiskScore(_ student: Student) -> Double {
        let attendance = student.attendance / 100.0
        let assignments = 0.88
        let engagement = 0.80
        let currGPA = student.currentAverage / 10.0

        return (attendance * 0.30 + assignments * 0.30 + engagement * 0.20 + currGPA * 0.20) * 100
    }
}
