import Foundation
import Observation

/// Model to store user's onboarding information
@Observable class UserOnboardingData {
    // Personal information
    var age: Int?
    var gender: Gender = .other
    var height: Double?
    var weight: Double?
    var units: MeasurementUnits = .metric

    // Fitness goals
    var fitnessGoals: [FitnessGoal] = []
    var experienceLevel: ExperienceLevel = .beginner

    // Workout preferences
    var workoutDaysPerWeek: Int = 3
    var preferredWorkoutDuration: Int = 30
    var availableEquipment: [Equipment] = []
    var preferredWorkoutEnvironment: WorkoutEnvironment = .home

    // Other preferences
    var dietaryRestrictions: [DietaryRestriction] = []

    // Onboarding progress
    var completedSteps: [OnboardingStep] = []

    // Calculate BMI if height and weight are available
    var bmi: Double? {
        guard let height = height, let weight = weight else { return nil }

        // Convert to metric for calculation if needed
        let weightInKg = units == .metric ? weight : weight * 0.453592
        let heightInM = units == .metric ? height / 100 : height * 0.0254

        return weightInKg / (heightInM * heightInM)
    }

    // Helper to check if a step is completed
    func isStepCompleted(_ step: OnboardingStep) -> Bool {
        return completedSteps.contains(step)
    }

    // Mark a step as completed
    func completeStep(_ step: OnboardingStep) {
        if !isStepCompleted(step) {
            completedSteps.append(step)
        }
    }
}

// MARK: - Enums for UserOnboardingData

enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case other = "Other"

    var id: String { self.rawValue }
}

enum MeasurementUnits: String, CaseIterable, Identifiable {
    case metric = "Metric (kg, cm)"
    case imperial = "Imperial (lb, ft/in)"

    var id: String { self.rawValue }
}

enum FitnessGoal: String, CaseIterable, Identifiable {
    case weightLoss = "Weight Loss"
    case muscleGain = "Muscle Gain"
    case strength = "Strength"
    case endurance = "Endurance"
    case flexibility = "Flexibility"
    case generalFitness = "General Fitness"

    var id: String { self.rawValue }

    var description: String {
        switch self {
        case .weightLoss:
            return "Reduce body fat and achieve a leaner physique"
        case .muscleGain:
            return "Build muscle mass and increase size"
        case .strength:
            return "Increase overall strength and power"
        case .endurance:
            return "Improve cardiovascular fitness and stamina"
        case .flexibility:
            return "Enhance range of motion and mobility"
        case .generalFitness:
            return "Maintain overall health and fitness"
        }
    }

    var iconName: String {
        switch self {
        case .weightLoss: return "scalemass"
        case .muscleGain: return "figure.arms.open"
        case .strength: return "dumbbell"
        case .endurance: return "figure.run"
        case .flexibility: return "figure.flexibility"
        case .generalFitness: return "heart.circle"
        }
    }
}

enum ExperienceLevel: String, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var id: String { self.rawValue }

    var description: String {
        switch self {
        case .beginner:
            return "New to fitness or returning after a long break"
        case .intermediate:
            return "Consistent with exercise for 6+ months"
        case .advanced:
            return "Very experienced, training regularly for 2+ years"
        }
    }
}

enum WorkoutEnvironment: String, CaseIterable, Identifiable {
    case home = "Home"
    case gym = "Gym"
    case both = "Both"

    var id: String { self.rawValue }
}

enum Equipment: String, CaseIterable, Identifiable {
    case none = "None"
    case resistanceBands = "Resistance Bands"
    case dumbbells = "Dumbbells"
    case kettlebells = "Kettlebells"
    case pullUpBar = "Pull-up Bar"
    case bench = "Bench"
    case barbell = "Barbell"
    case machines = "Machines"

    var id: String { self.rawValue }
}

enum DietaryRestriction: String, CaseIterable, Identifiable {
    case none = "None"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten-Free"
    case dairyFree = "Dairy-Free"
    case keto = "Keto"
    case paleo = "Paleo"

    var id: String { self.rawValue }
}

enum OnboardingStep: CaseIterable {
    case personalInfo
    case fitnessGoals
    case experienceLevel
    case workoutPreferences
    case dietaryInfo
    case summary
}
