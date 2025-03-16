import SwiftUI

// File: NewWorkoutView.swift
// Path: /FitnessFreaks/Views/Fitness/NewWorkoutView.swift

enum WorkoutCreationStep: Int, CaseIterable {
  case selectMuscle = 0
  case selectEquipment = 1
  case configureWorkout = 2
  
  var title: String {
    switch self {
    case .selectMuscle:
      return "Select Muscle"
    case .selectEquipment:
      return "Select Equipment"
    case .configureWorkout:
      return "Configure Workout"
    }
  }
}

struct WorkoutScalingButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.94 : 1)
      .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
  }
}

struct NewWorkoutView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var currentStep: WorkoutCreationStep = .selectMuscle
  
  var body: some View {
    ZStack {
      // Custom energetic background for workout creation
      ZStack {
        // Base dark background
        Color.black.ignoresSafeArea()

        // Energetic purple/blue radial gradient for fitness
        RadialGradient(
          gradient: Gradient(colors: [
            Color(red: 0.55, green: 0.35, blue: 0.95).opacity(0.7),  // Purple
            Color(red: 0.15, green: 0.3, blue: 0.8).opacity(0.3),  // Deep blue
            .clear,
          ]),
          center: .topTrailing,
          startRadius: 10,
          endRadius: 400
        )
        .ignoresSafeArea()

        // Accent for visual interest
        RadialGradient(
          gradient: Gradient(colors: [
            Color(red: 0.15, green: 0.85, blue: 0.55).opacity(0.5),  // Green accent
            .clear,
          ]),
          center: .bottomLeading,
          startRadius: 5,
          endRadius: 300
        )
        .ignoresSafeArea()

        // Subtle glass-like overlay
        Rectangle()
          .fill(.ultraThinMaterial)
          .opacity(0.1)
          .ignoresSafeArea()
      }

      VStack(spacing: 0) {
        // Close button and title
        headerView

        // Step indicator
        StepIndicatorView(currentStep: currentStep)
          .padding(.top, 8)
          .padding(.bottom, 8)

        // Content based on current step
        Group {
          switch currentStep {
          case .selectMuscle:
            SelectMuscleView(onNext: nextStep)
          case .selectEquipment:
            SelectEquipmentView(onNext: nextStep, onBack: previousStep)
          case .configureWorkout:
            ConfigureWorkoutView(onBack: previousStep, onComplete: completeWorkout)
          }
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
      }
    }
    .preferredColorScheme(.dark)
    .edgesIgnoringSafeArea(.bottom)
    .animation(.easeInOut(duration: 0.3), value: currentStep)
  }

  // Header with title and close button
  private var headerView: some View {
    HStack {
      // Title
      Text("Create Workout")
        .font(.system(size: 28, weight: .bold))
        .foregroundColor(.white)

      Spacer()

      // Close button
      Button {
        withAnimation {
          dismiss()
        }
      } label: {
        Image(systemName: "xmark")
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(.white)
          .padding(12)
          .background(
            Circle()
              .fill(.ultraThinMaterial)
              .opacity(0.7)
          )
      }
      .buttonStyle(WorkoutScalingButtonStyle()) // Fixed: Used a uniquely named button style
    }
    .padding(.horizontal, 20)
    .padding(.top, 16)
    .padding(.bottom, 16)
  }

  // Navigation functions
  private func nextStep() {
    if let nextStep = WorkoutCreationStep(rawValue: currentStep.rawValue + 1) {
      withAnimation {
        currentStep = nextStep
      }
    }
  }

  private func previousStep() {
    if let prevStep = WorkoutCreationStep(rawValue: currentStep.rawValue - 1) {
      withAnimation {
        currentStep = prevStep
      }
    }
  }

  private func completeWorkout() {
    // Here we would save the workout and dismiss
    dismiss()
  }
}

#Preview {
  NewWorkoutView()
}