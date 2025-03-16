import SwiftUI

// File: StepIndicatorView.swift
// Path: /FitnessFreaks/Views/Components/StepIndicatorView.swift

struct StepIndicatorView: View {
    let currentStep: WorkoutCreationStep
    
    var body: some View {
        VStack(spacing: 20) {
            // Line progress indicators
            HStack(spacing: 0) {
                ForEach(WorkoutCreationStep.allCases, id: \.rawValue) { step in
                    Rectangle()
                        .fill(getStepColor(for: step))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            // Step titles
            HStack(spacing: 0) {
                ForEach(WorkoutCreationStep.allCases, id: \.rawValue) { step in
                    Text(step.title)
                        .font(.system(size: 14, weight: step == currentStep ? .semibold : .medium))
                        .foregroundColor(getStepTextColor(for: step))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // Helper to get the color for each step indicator
    private func getStepColor(for step: WorkoutCreationStep) -> Color {
        if step.rawValue < currentStep.rawValue {
            // Completed steps
            return .accentBlue
        } else if step == currentStep {
            // Current step
            return .fitnessGradient1
        } else {
            // Future steps
            return Color.gray.opacity(0.3)
        }
    }
    
    // Helper to get text color for each step
    private func getStepTextColor(for step: WorkoutCreationStep) -> Color {
        if step == currentStep {
            return .white
        } else {
            return .white.opacity(0.5)
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        VStack(spacing: 20) {
            StepIndicatorView(currentStep: .selectMuscle)
            StepIndicatorView(currentStep: .selectEquipment)
            StepIndicatorView(currentStep: .configureWorkout)
        }
        .padding()
    }
}