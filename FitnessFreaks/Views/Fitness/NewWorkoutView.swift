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
  @State private var isLoaded = false
  
  var body: some View {
    ZStack {
      // Custom background that matches main app's style
      BackgroundGradientView(forTab: .fitness)
      
      VStack(spacing: 0) {
        // Close button and title
        headerView
          .padding(.horizontal, 20)
          .padding(.top, 16)
          .padding(.bottom, 16)
          .opacity(isLoaded ? 1 : 0)
          .offset(y: isLoaded ? 0 : 20)
          .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: isLoaded)

        // Step indicator
        StepIndicatorView(currentStep: currentStep)
          .padding(.top, 8)
          .padding(.bottom, 16)
          .opacity(isLoaded ? 1 : 0)
          .offset(y: isLoaded ? 0 : 20)
          .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.2), value: isLoaded)

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
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        isLoaded = true
      }
    }
  }

  // Header with title and close button
  private var headerView: some View {
    HStack {
      // Title
      VStack(alignment: .leading, spacing: 4) {
        Text("Create Workout")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.white)
          
        Text("Design your perfect routine")
          .font(.subheadline)
          .foregroundColor(.white.opacity(0.7))
      }

      Spacer()

      // Close button
      Button {
        withAnimation {
          dismiss()
        }
      } label: {
        ZStack {
          Circle()
            .fill(.ultraThinMaterial)
            .opacity(0.7)
            .frame(width: 46, height: 46)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

          Image(systemName: "xmark")
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
        }
      }
      .buttonStyle(WorkoutScalingButtonStyle())
    }
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