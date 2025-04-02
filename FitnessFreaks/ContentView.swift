import SwiftUI

// File: ContentView.swift
// Path: /FitnessFreaks/ContentView.swift

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var screenSize: CGSize = .zero
    private let tabItems = ["Homepage", "Fitness", "Chat", "Profile"]
    private let tabIcons = [
        "house.fill", "figure.strengthtraining.traditional", "bubble.left.fill", "person.fill",
    ]

    // Animation states
    @State private var isCardPressed = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with vibrant mint/teal gradient
                backgroundLayers

                VStack(spacing: 0) {
                    // Content based on selected tab
                    tabContent

                    // Custom tab bar
                    customTabBar
                }

               
            }
            .preferredColorScheme(.dark)
            .screenSize(geometry.size)
            .onAppear {
                self.screenSize = geometry.size
            }
            .onChange(of: geometry.size) { newSize in
                self.screenSize = newSize
            }
        }
    }

    // Content changes based on selected tab
    private var tabContent: some View {
        ZStack {
            if selectedTab == 0 {
                // Homepage tab (formerly Activity tab)
                HomeView()
            } else if selectedTab == 1 {
                // Fitness tab
                FitnessView()
            } else if selectedTab == 2 {
                // Chat tab - Now using the actual ChatView
                ChatView()
            } else {
                // Profile tab - Using the new ProfileView instead of placeholder
                ProfileView()
            }
        }
    }

    // Placeholder for tabs not yet implemented
    private func placeholderView(title: String, systemImage: String) -> some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 70))
                .foregroundColor(.accentGreen)
                .padding()
                .background(
                    Circle()
                        .fill(Color.accentGreen.opacity(0.1))
                        .frame(width: 150, height: 150)
                )

            Text("\(title) Coming Soon")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text("We're working on something amazing for you")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 32)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // Computed property for header opacity based on scroll position
    private var headerOpacity: Double {
        let threshold: CGFloat = -50
        return Double(min(1.0, max(0, abs(min(0, scrollOffset)) / abs(threshold))))
    }

    // Updated background with vibrant mint/teal radial gradient
    private var backgroundLayers: some View {
        ZStack {
            // Pure black background
            Color.black
                .ignoresSafeArea()

            // Vibrant mint/teal radial gradient with frosted light source effect
            VStack {
                ZStack {
                    // Main radial gradient with vibrant teal/mint
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.vibrantMint, Color.vibrantTeal.opacity(0.5), .clear,
                        ]),
                        center: .topTrailing,
                        startRadius: 20,
                        endRadius: 600
                    )
                    .frame(
                        width: screenSize.width, height: screenSize.height * 0.5
                    )
                    .opacity(0.45)
                    .blur(radius: 40)  // Soft blur for frosted effect

                    // Secondary smaller highlight for "light source" effect
                    RadialGradient(
                        gradient: Gradient(colors: [.white.opacity(0.4), .clear]),
                        center: .topTrailing,
                        startRadius: 5,
                        endRadius: 100
                    )
                    .frame(width: 200, height: 200)
                    .offset(x: -20, y: 20)
                    .blur(radius: 20)
                }
                Spacer()
            }
            .ignoresSafeArea()

            // Subtle glass-like overlay for entire screen
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.1)
                .ignoresSafeArea()
        }
    }

   

    // Custom tab bar with glass effect and selection animations
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabItems.count, id: \.self) { index in
                tabButton(for: index)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(tabBarBackground)
    }
    
    // Extracted tab button to simplify expressions
    private func tabButton(for index: Int) -> some View {
        Button(action: {
            // Enhanced animation with spring and bounce effect
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.2)) {
                selectedTab = index
            }
        }) {
            VStack(spacing: 4) {
                // Tab icon
                Image(systemName: tabIcons[index])
                    .font(.system(size: 22))
                    .foregroundColor(selectedTab == index ? .accentGreen : .textSecondary)
                    .symbolEffect(.bounce, options: .speed(1.5), value: selectedTab == index)
                    .frame(height: 24)
                    .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                    .shadow(
                        color: selectedTab == index ? Color.accentGreen.opacity(0.6) : .clear, 
                        radius: 5, x: 0, y: 3
                    )
                    .contentTransition(.symbolEffect(.replace.downUp.byLayer))

                // Tab label
                Text(tabItems[index])
                    .font(.caption2)
                    .fontWeight(selectedTab == index ? .semibold : .regular)
                    .foregroundColor(selectedTab == index ? .textPrimary : .textTertiary)
                    .opacity(selectedTab == index ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(tabIndicator(isSelected: selectedTab == index))
        }
        .accessibilityLabel(tabItems[index])
        .accessibilityAddTraits(selectedTab == index ? [.isSelected] : [])
        .buttonStyle(TabButtonStyle())
    }
    
    // Tab indicator background
    private func tabIndicator(isSelected: Bool) -> some View {
        ZStack {
            if isSelected {
                // Enhanced tab indicator with morphing animation
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.accentGreen.opacity(0.18))
                    .frame(width: 65, height: 36)
                    .blur(radius: 8)
                    .opacity(0.8)
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0.3), value: isSelected)
    }
    
    // Tab bar background with sliding indicator
    private var tabBarBackground: some View {
        ZStack {
            // Base background with material effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.8)
                .background(Color.black.opacity(0.5))
                .shadow(color: .black.opacity(0.2), radius: 8, y: -4)

            // Top border with gradient
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2), Color.white.opacity(0.05),
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 0.5)
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea()
    }
}

// Custom button style specifically for tab buttons with haptic feedback
struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { wasPressed, isPressed in
                if isPressed {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}

// For SwiftUI preview
#Preview {
    ContentView()
}