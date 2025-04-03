import SwiftUI

// MARK: - Onboarding View

struct OnboardingView: View {
  @State private var onboardingData = UserOnboardingData()
  @State private var currentStep: OnboardingStep = .personalInfo
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      ZStack {
        // Background that matches the app theme
          BackgroundGradientView(forTab: .chat)

        // Overlay blur effect to enhance depth
        Rectangle()
          .fill(.ultraThinMaterial.opacity(0.1))
          .ignoresSafeArea()

        VStack(spacing: 25) {
          // Progress indicator
          OnboardingProgressView(currentStep: currentStep)
            .padding(.top, 15)

          // Title for current step
          Text(titleForStep(currentStep))
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 25)
            .padding(.top, 5)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

          // Main content view that changes based on current step
          ScrollView {
            currentStepView
              .animation(.easeInOut(duration: 0.3), value: currentStep)
              .transition(.opacity)
              .padding(.horizontal, 25)
          }
          .scrollIndicators(.hidden)

          // Navigation buttons
          navigationButtons
            .padding(.horizontal, 25)
            .padding(.bottom, 30)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .statusBar(hidden: true)
    }
  }

  // View that displays based on the current step
  @ViewBuilder
  private var currentStepView: some View {
    switch currentStep {
    case .personalInfo:
      PersonalInfoView(onboardingData: $onboardingData)
    case .fitnessGoals, .experienceLevel, .workoutPreferences, .dietaryInfo, .summary:
      // Placeholder for future steps
      Text("This step will be implemented next")
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .glassCard()
    }
  }

  // Title for each step
  private func titleForStep(_ step: OnboardingStep) -> String {
    switch step {
    case .personalInfo:
      return "Tell us about yourself"
    case .fitnessGoals:
      return "What are your fitness goals?"
    case .experienceLevel:
      return "What's your experience level?"
    case .workoutPreferences:
      return "Workout preferences"
    case .dietaryInfo:
      return "Dietary information"
    case .summary:
      return "Review your profile"
    }
  }

  // Next and back buttons
  private var navigationButtons: some View {
    HStack(spacing: 20) {
      // Back button
      if currentStep != OnboardingStep.allCases.first! {
        Button(action: goToPreviousStep) {
          HStack(spacing: 8) {
            Image(systemName: "chevron.left")
            Text("Back")
          }
          .font(.system(size: 16, weight: .semibold, design: .rounded))
          .padding(.vertical, 16)
          .padding(.horizontal, 24)
          .foregroundColor(.white)
          .contentShape(Rectangle())
        }
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color.white.opacity(0.10))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
      } else {
        Spacer()
      }

      Spacer()

      // Next/Finish button
      Button(action: handleNextButtonPressed) {
        HStack(spacing: 10) {
          Text(isLastStep ? "Finish" : "Next")
          Image(systemName: "chevron.right")
        }
        .font(.system(size: 16, weight: .semibold, design: .rounded))
        .padding(.vertical, 16)
        .padding(.horizontal, 30)
        .foregroundColor(.white)
        .contentShape(Rectangle())
      }
      .background(
        LinearGradient(
          gradient: Gradient(
            colors: [.profileGradient1, .profileGradient2]
          ),
          startPoint: .leading,
          endPoint: .trailing
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
      )
      .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
      .opacity(canMoveToNextStep ? 1.0 : 0.5)
      .disabled(!canMoveToNextStep)
    }
  }

  // Logic to handle the next button
  private func handleNextButtonPressed() {
    if isLastStep {
      completeOnboarding()
    } else {
      goToNextStep()
    }
  }

  // Navigate to the next step
  private func goToNextStep() {
    let allSteps = OnboardingStep.allCases
    if let currentIndex = allSteps.firstIndex(of: currentStep),
      currentIndex < allSteps.count - 1
    {
      withAnimation {
        currentStep = allSteps[currentIndex + 1]
      }
    }
  }

  // Navigate to the previous step
  private func goToPreviousStep() {
    let allSteps = OnboardingStep.allCases
    if let currentIndex = allSteps.firstIndex(of: currentStep),
      currentIndex > 0
    {
      withAnimation {
        currentStep = allSteps[currentIndex - 1]
      }
    }
  }

  // Skip onboarding completely
  private func skipOnboarding() {
    // This would typically save minimal default values
    // and mark onboarding as complete in app preferences
    dismiss()
  }

  // Complete the onboarding process
  private func completeOnboarding() {
    // Save the onboarding data to persistent storage
    // Set preference flag that onboarding is complete
    dismiss()
  }

  // Check if current step is the last one
  private var isLastStep: Bool {
    currentStep == OnboardingStep.allCases.last
  }

  // Verify if user can proceed to next step
  private var canMoveToNextStep: Bool {
    switch currentStep {
    case .personalInfo:
      return onboardingData.age != nil && onboardingData.height != nil
        && onboardingData.weight != nil
    case .fitnessGoals:
      return !onboardingData.fitnessGoals.isEmpty
    case .experienceLevel:
      return true  // Always valid as we have a default
    case .workoutPreferences:
      return true  // Always valid as we have defaults
    case .dietaryInfo:
      return true  // Optional step
    case .summary:
      return true  // Review screen, always valid
    }
  }
}

// MARK: - OnboardingProgressView

struct OnboardingProgressView: View {
  let currentStep: OnboardingStep
  private let allSteps = OnboardingStep.allCases

  // Environment awareness
  @Environment(\.colorScheme) private var colorScheme

  // Animation properties
  @State private var animateIndicator = false

  // Namespace for matched geometry effect
  @Namespace private var indicatorAnimation

  var body: some View {
    // Line progress indicators
    HStack(spacing: 4) {
      ForEach(allSteps.indices, id: \.self) { index in
        let step = allSteps[index]
        Capsule()
          .fill(getStepColor(for: step))
          .frame(height: 6)
          .frame(maxWidth: .infinity)
          .overlay(
            step == currentStep
              ? Capsule()
                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                .matchedGeometryEffect(id: "currentIndicator", in: indicatorAnimation)
              : nil
          )
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
  private func getStepColor(for step: OnboardingStep) -> Color {
    if let stepIndex = allSteps.firstIndex(of: step),
      let currentIndex = allSteps.firstIndex(of: currentStep)
    {
      if stepIndex < currentIndex {
        // Completed steps - Use a distinct completed color
        return Color(red: 0.0, green: 0.8, blue: 0.95)  // accentBlue
      } else if step == currentStep {
        // Current step - Use profile gradient color with linear gradient
        return Color(red: 0.0, green: 0.7, blue: 0.65)  // profileGradient1
      } else {
        // Future steps - Dimmed color
        return colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.15)
      }
    }
    return Color.gray.opacity(0.3)  // Fallback color
  }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
