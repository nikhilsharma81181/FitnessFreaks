import SwiftUI

// File: SelectMuscleView.swift
// Path: /FitnessFreaks/Views/Fitness/SelectMuscleView.swift

struct MuscleGroup: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

struct SelectMuscleView: View {
    let onNext: () -> Void
    
    @State private var selectedMuscles: Set<UUID> = []
    @State private var isLoaded = false
    
    // Sample muscle groups
    private let muscleGroups = [
        MuscleGroup(name: "Chest", icon: "figure.arms.open", color: Color(red: 0.0, green: 0.8, blue: 0.7)),
        MuscleGroup(name: "Back", icon: "figure.stand", color: Color.accentBlue),
        MuscleGroup(name: "Shoulders", icon: "person.fill", color: Color.accentPurple),
        MuscleGroup(name: "Arms", icon: "figure.arms.open", color: Color(red: 0.95, green: 0.3, blue: 0.25)),
        MuscleGroup(name: "Legs", icon: "figure.walk", color: Color(red: 0.95, green: 0.3, blue: 0.35)),
        MuscleGroup(name: "Core", icon: "figure.core.training", color: Color(red: 0.0, green: 0.9, blue: 0.7)),
        MuscleGroup(name: "Full Body", icon: "figure.strengthtraining.functional", color: Color(red: 0.0, green: 0.75, blue: 0.8)),
        MuscleGroup(name: "Cardio", icon: "heart.fill", color: Color(red: 0.95, green: 0.6, blue: 0.3))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Content area
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Muscle group grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(muscleGroups) { muscle in
                            muscleGroupCard(muscle)
                                .opacity(isLoaded ? 1 : 0)
                                .offset(y: isLoaded ? 0 : 20)
                                .animation(
                                    .spring(response: 0.4, dampingFraction: 0.7)
                                    .delay(0.1 + Double(muscleGroups.firstIndex(where: { $0.id == muscle.id }) ?? 0) * 0.05),
                                    value: isLoaded
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Add some spacing at the bottom to ensure the last row is visible
                    Spacer()
                        .frame(height: 100)
                }
            }
            
            // Fixed bottom button area
            VStack {
                // Next button
                Button(action: onNext) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.fitnessGradient1, .fitnessGradient2]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 50)
                        .shadow(color: Color.fitnessGradient1.opacity(0.5), radius: 8, x: 0, y: 4)
                        .overlay(
                            Text("Next")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                .disabled(selectedMuscles.isEmpty)
                .opacity(selectedMuscles.isEmpty ? 0.6 : 1.0)
                .opacity(isLoaded ? 1 : 0)
                .offset(y: isLoaded ? 0 : 20)
                .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.3), value: isLoaded)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLoaded = true
            }
        }
    }
    
    // Muscle group card
    private func muscleGroupCard(_ muscle: MuscleGroup) -> some View {
        let isSelected = selectedMuscles.contains(muscle.id)
        
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if isSelected {
                    selectedMuscles.remove(muscle.id)
                } else {
                    selectedMuscles.insert(muscle.id)
                }
            }
        }) {
            VStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? muscle.color : Color.black.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? muscle.color : Color.clear,
                                    lineWidth: isSelected ? 2 : 0
                                )
                        )
                    
                    Image(systemName: muscle.icon)
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }
                
                // Name
                Text(muscle.name)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? (muscle.color == .white ? Color.accentBlue : muscle.color) : Color.clear,
                                lineWidth: isSelected ? 2 : 0
                            )
                    )
            )
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        SelectMuscleView(onNext: {})
    }
}