//
//  RoleSelectionView.swift
//  UniSightAI
//
//  Created by Anila on 31.5.2026.
//

import SwiftUI

enum UserRole {
    case student, professor, coordinator
}

struct RoleOption: Identifiable {
    let id = UUID()
    let role: UserRole
    let title: String
    let subtitle: String
    let icon: String
}

struct RoleSelectionView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool
    @Binding var isPresented: Bool

    @State private var selectedRole: UserRole? = .student

    let roles: [RoleOption] = [
        RoleOption(role: .student, title: "Student", subtitle: "Track your grades and personalised study plan.", icon: "graduationcap.fill"),
        RoleOption(role: .professor, title: "Professor", subtitle: "Predict student outcomes and intervene early.", icon: "brain.head.profile"),
        RoleOption(role: .coordinator, title: "Coordinator", subtitle: "Cohort-wide analytics and risk dashboards.", icon: "compass.drawing")
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.80, green: 0.0, blue: 0.0).opacity(0.10))
                                .frame(width: 70, height: 70)
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .font(.system(size: 30))
                                .foregroundColor(Color(red: 0.80, green: 0.0, blue: 0.0))
                        }
                        Text("Select your role")
                            .font(.system(size: 22, weight: .bold))
                        Text("Choose how you'll use UniSight AI")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Role cards
                    VStack(spacing: 12) {
                        ForEach(roles) { option in
                            RoleCard(
                                option: option,
                                isSelected: selectedRole == option.role
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedRole = option.role
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()

                    // Continue button
                    Button(action: handleContinue) {
                        HStack(spacing: 8) {
                            Text("Continue")
                                .font(.system(size: 17, weight: .semibold))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            selectedRole != nil
                            ? Color(red: 0.80, green: 0.0, blue: 0.0)
                            : Color.gray.opacity(0.4)
                        )
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .shadow(color: Color(red: 0.80, green: 0.0, blue: 0.0).opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(selectedRole == nil)
                    .padding(.bottom, 36)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }

    private func handleContinue() {
        guard let role = selectedRole else { return }
        isPresented = false
        switch role {
        case .coordinator:
            isAdmin = true
            isLoggedIn = true
        default:
            isAdmin = false
            isLoggedIn = true
        }
    }
}

// MARK: - Role Card
struct RoleCard: View {
    let option: RoleOption
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(isSelected ? Color(red: 0.80, green: 0.0, blue: 0.0) : Color(.systemGray5))
                    .frame(width: 48, height: 48)
                Image(systemName: option.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .white : .gray)
            }

            // Text
            VStack(alignment: .leading, spacing: 3) {
                Text(option.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                Text(option.subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            // Radio button
            ZStack {
                Circle()
                    .stroke(isSelected ? Color(red: 0.80, green: 0.0, blue: 0.0) : Color(.systemGray3), lineWidth: 2)
                    .frame(width: 22, height: 22)
                if isSelected {
                    Circle()
                        .fill(Color(red: 0.80, green: 0.0, blue: 0.0))
                        .frame(width: 12, height: 12)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: isSelected ? Color(red: 0.80, green: 0.0, blue: 0.0).opacity(0.15) : .black.opacity(0.05), radius: 8, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color(red: 0.80, green: 0.0, blue: 0.0) : Color.clear, lineWidth: 2)
        )
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView(isLoggedIn: .constant(false), isAdmin: .constant(false), isPresented: .constant(true))
    }
}
