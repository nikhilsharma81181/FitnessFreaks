import SwiftUI

// File: StepIndicatorView.swift
// Path: /FitnessFreaks/Views/Components/StepIndicatorView.swift

struct StepIndicatorView: View {
    let currentStep: WorkoutCreationStep
    private let steps = WorkoutCreationStep.allCases
    
    var body: some View {
        VStack(spacing: 8) { // Reduced spacing between lines and text
            // Line progress indicators
            HStack(spacing: 4) { // Add spacing between lines
                ForEach(steps, id: \.rawValue) { step in
                    Capsule() // Use Capsule for rounded ends
                        .fill(getStepColor(for: step))
                        .frame(height: 5)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            // Step titles aligned below indicators
            HStack(spacing: 4) { // Match spacing
                ForEach(steps, id: \.rawValue) { step in
                    Text(step.title)
                        .font(.system(size: 12, weight: step == currentStep ? .semibold : .regular)) // Adjusted weight
                        .foregroundColor(getStepTextColor(for: step))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8) // Allow text shrinking
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // Helper to get the color for each step indicator line
    private func getStepColor(for step: WorkoutCreationStep) -> Color {
        if step.rawValue < currentStep.rawValue {
            // Completed steps - Use a distinct completed color (e.g., accent blue)
            return Color.accentBlue
        } else if step == currentStep {
            // Current step - Use the theme gradient primary color
            return Color(red: 0.95, green: 0.3, blue: 0.35) // Energetic red from workout theme
        } else {
            // Future steps - Dimmed color
            return Color.gray.opacity(0.3)
        }
    }
    
    // Helper to get text color for each step title
    private func getStepTextColor(for step: WorkoutCreationStep) -> Color {
        if step == currentStep {
            return .white // Highlight current step text
        } else if step.rawValue < currentStep.rawValue {
             return .white.opacity(0.7) // Slightly dimmed completed steps
        } else {
            return .white.opacity(0.5) // More dimmed future steps
        }
    }
}

#Preview {
    ZStack {
        // Background to simulate the workout view
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color(red: 0.1, green: 0.1, blue: 0.2)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
        
        VStack(spacing: 40) {
            StepIndicatorView(currentStep: .selectMuscle)
            StepIndicatorView(currentStep: .selectEquipment)
            StepIndicatorView(currentStep: .configureWorkout)
        }
        .padding()
    }
}