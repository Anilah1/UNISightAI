//
//  ContentView.swift
//  UniSightAI
//
//  Created by Anila on 29.5.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var isAdmin = false
    let student = Student.sample
    
    var body: some View {
        if !isLoggedIn {
            LoginView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
        } else if isAdmin {
            AdminDashboardView(isLoggedIn: $isLoggedIn)
        } else {
            studentTabView
        }
    }
    
    private var studentTabView: some View {
        TabView {
            HomeView(student: student)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Home")
                }
            InsightsView(student: student)
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Insights")
                }
            GradesView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard.fill")
                    Text("Grades")
                }
            AlertsView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Alerts")
                }
            ProfileView(student: student, isLoggedIn: $isLoggedIn)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(Color(red: 0.80, green: 0.0, blue: 0.0))
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
