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
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabIcons[index])
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == index ? .accentGreen : .textSecondary)
                            .scaleEffect(selectedTab == index ? 1.1 : 1.0)
                            .shadow(
                                color: selectedTab == index
                                    ? Color.accentGreen.opacity(0.5) : .clear, radius: 5, x: 0, y: 3
                            )

                        Text(tabItems[index])
                            .font(.caption2)
                            .foregroundColor(selectedTab == index ? .textPrimary : .textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        ZStack {
                            if selectedTab == index {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentGreen.opacity(0.15))
                                    .frame(width: 60, height: 32)
                                    .blur(radius: 12)
                                    .opacity(0.7)
                            }
                        }
                    )
                }
                .buttonStyle(ContentScalingButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.7)
                    .background(Color.black.opacity(0.4))

                // Top border
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
        )
    }
}

// Custom button style for scaling animation
struct ContentScalingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// For SwiftUI preview
#Preview {
    ContentView()
}