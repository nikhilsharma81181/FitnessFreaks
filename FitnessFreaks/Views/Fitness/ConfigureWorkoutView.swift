import SwiftUI

// File: ConfigureWorkoutView.swift
// Path: /FitnessFreaks/Views/Fitness/ConfigureWorkoutView.swift

struct ConfigureWorkoutView: View {
    let onBack: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Section title
                Text("Configure Workout")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                
                // Placeholder text
                Text("This is a placeholder for the workout configuration screen")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 60)
                
                Spacer(minLength: 80)
            }
        }
        .scrollIndicators(.hidden)
        
        // Bottom fixed buttons
        VStack {
            Spacer()
            
            HStack(spacing: 16) {
                // Back button
                Button(action: onBack) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 50)
                        .overlay(
                            Text("Back")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                .frame(maxWidth: .infinity)
                
                // Complete button
                Button(action: onComplete) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.fitnessGradient1, .fitnessGradient2]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 50)
                        .overlay(
                            Text("Create Workout")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        ConfigureWorkoutView(onBack: {}, onComplete: {})
    }
}