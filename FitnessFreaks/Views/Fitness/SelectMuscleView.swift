import SwiftUI

// File: SelectMuscleView.swift
// Path: /FitnessFreaks/Views/Fitness/SelectMuscleView.swift

struct MuscleGroup: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

// Define a struct for header parameters that conforms to Equatable
struct HeaderAnimationParams: Equatable {
    let offset: CGFloat
    let opacity: CGFloat
}

struct SelectMuscleView: View {
    let onNext: () -> Void
    
    @State private var selectedMuscles: Set<UUID> = []
    @State private var isLoaded = false
    @State private var animateArrow = false // State for arrow animation
    @State private var scrollOffset: CGFloat = 0 // Track scroll position
    
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

    // Very dark teal color for button text/icon
    private var buttonTextColor: Color { Color(red: 0.0, green: 0.2, blue: 0.25) }
    
    // Computed properties based on scroll position
    private var headerOffset: CGFloat {
        let fullHideThreshold: CGFloat = 120 // Scroll position where header is fully hidden
        
        if scrollOffset <= 0 {
            return 0 // Not scrolled - no offset
        } else if scrollOffset >= fullHideThreshold {
            return -60 // Fully scrolled - maximum offset
        } else {
            // Linear interpolation
            return -60 * (scrollOffset / fullHideThreshold)
        }
    }
    
    private var headerOpacity: CGFloat {
        let threshold: CGFloat = 70 // Threshold where header completely fades
        return max(0, 1.0 - (scrollOffset / threshold))
    }
    
    private var subtitleOpacity: CGFloat {
        // Subtitle fades faster than the main title
        return min(1, headerOpacity * 1.5)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Instruction header with dynamic transformations
            instructionHeader
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .opacity(isLoaded && headerOpacity > 0 ? headerOpacity : 0)
                .offset(y: isLoaded ? headerOffset : 10)
                .animation(.interpolatingSpring(stiffness: 150, damping: 20), value: scrollOffset)
            
            // Content area with scroll tracking
            ScrollView(showsIndicators: false) {
                // Scroll position detection
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: MuscleViewScrollOffsetKey.self,
                        value: geometry.frame(in: .named("scrollView")).minY
                    )
                }
                .frame(height: 0)
                
                VStack(spacing: 16) {
                    // Muscle group grid
                    muscleGrid
                        .padding(.horizontal, 20)
                    
                    Spacer().frame(height: 120) // Increased bottom padding for scroll visibility
                }
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(MuscleViewScrollOffsetKey.self) { value in
                // Convert positive scroll values to negative offset and vice versa
                scrollOffset = -min(0, value)
            }
            
            // Fixed bottom button area
            footerButtonArea
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLoaded = true
            }
            // Start the arrow animation on appear
            startArrowAnimation()
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
                    .opacity(subtitleOpacity)
            }
            Spacer()
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
            Button(action: {
                // Trigger haptic feedback on tap if needed
                // HapticManager.shared.impact(style: .medium)
                onNext()
            }) {
                HStack(spacing: 8) { // Adjusted spacing
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .offset(x: animateArrow ? 5 : 0) // Apply animation offset
                }
                .foregroundColor(selectedMuscles.isEmpty ? .white.opacity(0.6) : buttonTextColor) // Change text color
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
            .stroke(Color.white.opacity(selectedMuscles.isEmpty ? 0.05 : 0.1), lineWidth: 0.5)
    }

    private var shadowColor: Color {
        selectedMuscles.isEmpty 
        ? Color.black.opacity(0.1) 
        : enabledButtonColor.opacity(0.5) // Use consistent theme color for enabled shadow
    }
    
    private var disabledButtonGradient: LinearGradient {
         LinearGradient(
            gradient: Gradient(colors: [
                Color.gray.opacity(0.2), // Slightly lighter disabled state
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
    
    // MARK: - Animation Helpers
    
    private func startArrowAnimation() {
        // Only animate if muscles are selected
        guard !selectedMuscles.isEmpty else { 
            animateArrow = false // Reset if becomes disabled
            return 
        }
        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
            animateArrow = true
        }
    }
}

// MARK: - Preference Key for Scroll Position
struct MuscleViewScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ZStack {
        BackgroundGradientView(forTab: .fitness)
        SelectMuscleView(onNext: {})
    }
}