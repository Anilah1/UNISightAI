//
//  UniSightAIApp.swift
//  UniSightAI
//
//  Created by Anila on 29.5.2026.
//

import SwiftUI

@main
struct UniSightAIApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .preferredColorScheme(.none)
        }
    }
}
