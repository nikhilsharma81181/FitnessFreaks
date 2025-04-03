import SwiftUI

// File: WorkoutStepIndicatorView.swift
// Path: /FitnessFreaks/Views/Components/WorkoutStepIndicatorView.swift

struct WorkoutStepIndicatorView: View {
    let currentStep: WorkoutCreationStep
    private let steps = WorkoutCreationStep.allCases

    // Animation properties
    @State private var animateIndicator = false

    var body: some View {
        // Line progress indicators
        HStack(spacing: 4) {
            ForEach(steps, id: \.rawValue) { step in
                Capsule()
                    .fill(getStepColor(for: step))
                    .frame(height: 6)  // Slightly increased height for better visibility
                    .frame(maxWidth: .infinity)
                    .opacity(animateIndicator ? 1 : 0.6)
                    .scaleEffect(
                        y: step == currentStep && animateIndicator ? 1.2 : 1, anchor: .center
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentStep)
                    .animation(.easeInOut(duration: 0.3), value: animateIndicator)
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            // Animate the indicator when it appears
            withAnimation(.easeInOut(duration: 0.5).delay(0.1)) {
                animateIndicator = true
            }
        }
    }

    // Helper to get the color for each step indicator line
    private func getStepColor(for step: WorkoutCreationStep) -> Color {
        if step.rawValue < currentStep.rawValue {
            // Completed steps - Use a distinct completed color (e.g., accent blue)
            return Color.accentBlue
        } else if step == currentStep {
            // Current step - Use the theme gradient primary color
            return Color(red: 0.95, green: 0.3, blue: 0.35)  // Energetic red from workout theme
        } else {
            // Future steps - Dimmed color
            return Color.gray.opacity(0.3)
        }
    }
}

#Preview {
    ZStack {
        // Background to simulate the workout view
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black,
                Color(red: 0.1, green: 0.1, blue: 0.2),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)

        VStack(spacing: 40) {
            // Show all three possible states
            WorkoutStepIndicatorView(currentStep: .selectMuscle)
            WorkoutStepIndicatorView(currentStep: .selectEquipment)
            WorkoutStepIndicatorView(currentStep: .configureWorkout)

            // Workout creation header demo
            VStack(spacing: 12) {
                Text("Create Workout")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                WorkoutStepIndicatorView(currentStep: .selectMuscle)

                Text("Select Muscle Groups")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 8)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.5))
            )
        }
        .padding()
    }
}
