//
//  FitnessFreaksApp.swift
//  FitnessFreaks
//
//  Created by Nikhil Sharma on 10/03/25.
//

import SwiftUI

@main
struct FitnessFreaksApp: App {
    @State private var onboardingCompleted = false
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup {
            if !isAuthenticated {
                LoginView(isAuthenticated: $isAuthenticated)
            } else if !onboardingCompleted {
                OnboardingView()
                    .onDisappear {
                        // Mark onboarding as completed when dismissed
                        onboardingCompleted = true
                    }
            } else {
                ContentView()
            }
        }
    }
}
