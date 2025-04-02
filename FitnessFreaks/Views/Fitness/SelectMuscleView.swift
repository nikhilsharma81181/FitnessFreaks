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
    
    // Consistent color palette from the main app
    private let muscleGroups = [
        MuscleGroup(name: "Chest", icon: "figure.arms.open", color: Color(red: 0.0, green: 0.9, blue: 0.7)),    // vibrantMint
        MuscleGroup(name: "Back", icon: "figure.stand", color: Color.blue),                             // accentBlue
        MuscleGroup(name: "Shoulders", icon: "person.fill", color: Color(red: 0.55, green: 0.35, blue: 0.95)), // accentPurple
        MuscleGroup(name: "Arms", icon: "figure.arms.open", color: Color(red: 0.95, green: 0.3, blue: 0.35)), // accentRed
        MuscleGroup(name: "Legs", icon: "figure.walk", color: Color(red: 1.0, green: 0.6, blue: 0.0)),    // accentOrange
        MuscleGroup(name: "Core", icon: "figure.core.training", color: Color(red: 0.15, green: 0.85, blue: 0.55)), // accentGreen
        MuscleGroup(name: "Full Body", icon: "figure.strengthtraining.functional", color: Color(red: 0.0, green: 0.75, blue: 0.8)), // vibrantTeal
        MuscleGroup(name: "Cardio", icon: "heart.fill", color: Color.pink) // Use a distinct color like pink
    ]
    
    // Determine the primary theme color for the button/shadow when enabled
    private var enabledButtonColor: Color { Color(red: 0.0, green: 0.9, blue: 0.7) } // vibrantMint
    private var enabledButtonGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [enabledButtonColor, Color(red: 0.0, green: 0.75, blue: 0.8)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            // Instruction header
            instructionHeader
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .opacity(isLoaded ? 1 : 0)
                .offset(y: isLoaded ? 0 : 10)
                .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: isLoaded)
            
            // Content area
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Muscle group grid
                    muscleGrid
                        .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 120) // Increased bottom padding for scroll visibility
                }
            }
            
            // Fixed bottom button area
            footerButtonArea
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLoaded = true
            }
        }
    }
    
    // MARK: - Subviews

    private var instructionHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Select Muscle Groups")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Choose the areas you want to focus on")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
            
            // Selection counter
            selectionCounter
        }
    }

    private var selectionCounter: some View {
        ZStack {
            Circle()
                .fill(enabledButtonGradient)
                .frame(width: 36, height: 36) // Slightly larger counter
                .shadow(color: enabledButtonColor.opacity(0.4), radius: 5, x: 0, y: 2)
            
            Text("\(selectedMuscles.count)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private var muscleGrid: some View {
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
    }

    private var footerButtonArea: some View {
        VStack {
            Button(action: onNext) {
                HStack(spacing: 12) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(buttonBackground)
                .overlay(buttonOverlay)
                .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            }
            .disabled(selectedMuscles.isEmpty)
            .opacity(isLoaded ? 1 : 0)
            .offset(y: isLoaded ? 0 : 20)
            .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.3), value: isLoaded)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32) // Standard bottom padding
        }
        .background(footerBackground)
    }

    // MARK: - Button Background/Overlay/Shadow Helpers

    @ViewBuilder private var buttonBackground: some View {
        Capsule()
            .fill(
                selectedMuscles.isEmpty 
                ? disabledButtonGradient
                : enabledButtonGradient
            )
    }

    private var buttonOverlay: some View {
        Capsule()
            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
    }

    private var shadowColor: Color {
        selectedMuscles.isEmpty 
        ? Color.black.opacity(0.1) 
        : enabledButtonColor.opacity(0.5) // Use consistent theme color for enabled shadow
    }
    
    private var disabledButtonGradient: LinearGradient {
         LinearGradient(
            gradient: Gradient(colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.3)
            ]),
            startPoint: .leading,
            endPoint: .trailing
         )
    }

    // MARK: - Muscle Card
    
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
            VStack(spacing: 16) {
                cardIcon(muscle: muscle, isSelected: isSelected)
                cardName(muscle: muscle, isSelected: isSelected)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(cardBackground(muscle: muscle, isSelected: isSelected))
            .scaleEffect(isSelected ? 1.03 : 1.0) // Slightly more pronounced scale
        }
        .buttonStyle(WorkoutScalingButtonStyle()) // Use the custom scaling effect
    }

    private func cardIcon(muscle: MuscleGroup, isSelected: Bool) -> some View {
        ZStack {
            // Base circle background
            Circle()
                .fill(isSelected ? muscle.color.opacity(0.25) : Color.black.opacity(0.2))
                .frame(width: 64, height: 64)
            
            // Selected state accent border
            if isSelected {
                Circle()
                    .stroke(muscle.color, lineWidth: 2)
                    .frame(width: 68, height: 68) // Slightly larger to stand out
            }
            
            // Icon
            Image(systemName: muscle.icon)
                .font(.system(size: 28))
                .foregroundColor(isSelected ? muscle.color : .white.opacity(0.7))
                .shadow(color: isSelected ? muscle.color.opacity(0.3) : .clear, radius: 5) // Add glow if selected
        }
    }

    private func cardName(muscle: MuscleGroup, isSelected: Bool) -> some View {
        Text(muscle.name)
            .font(.system(size: 16, weight: isSelected ? .bold : .medium))
            .foregroundColor(isSelected ? .white : .white.opacity(0.8))
    }

    private func cardBackground(muscle: MuscleGroup, isSelected: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.2))
            
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .opacity(0.6)
            
            // Selected state gradient overlay
            if isSelected {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [muscle.color.opacity(0.2), muscle.color.opacity(0.05)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.overlay)
            }
            
            // Border
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    cardBorderGradient(muscle: muscle, isSelected: isSelected),
                    lineWidth: isSelected ? 2.0 : 0.5 // Thicker border when selected
                )
        }
    }

    private func cardBorderGradient(muscle: MuscleGroup, isSelected: Bool) -> LinearGradient {
        isSelected 
        ? LinearGradient( // Vibrant border for selected state
            gradient: Gradient(colors: [muscle.color.opacity(0.8), muscle.color.opacity(0.4)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        : LinearGradient( // Subtle border for unselected state
            gradient: Gradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.03)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Footer Background
    
    private var footerBackground: some View {
        // Gradient overlay for the footer to blend with the background
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black.opacity(0.0), // Transparent at the top
                Color.black.opacity(0.4), // Semi-transparent in the middle
                Color.black.opacity(0.6)  // More opaque at the bottom
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 120) // Match the Spacer height in ScrollView
        .allowsHitTesting(false) // Allow taps to pass through to the button
        .background(.ultraThinMaterial.opacity(0.4))
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ZStack {
        BackgroundGradientView(forTab: .fitness)
        SelectMuscleView(onNext: {})
    }
}