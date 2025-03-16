import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var scrollOffset: CGFloat = 0
    private let tabItems = ["Homepage", "Fitness", "Chat", "Profile"]
    private let tabIcons = [
        "house.fill", "figure.strengthtraining.traditional", "bubble.left.fill", "person.fill",
    ]

    // Animation states
    @State private var isCardPressed = false

    var body: some View {
        ZStack {
            // Background with vibrant mint/teal gradient
            backgroundLayers

            VStack(spacing: 0) {
                // Content based on selected tab
                tabContent

                // Custom tab bar
                customTabBar
            }

            // Animated sticky header
            VStack {
                if selectedTab != 1 {  // Only show header for non-Fitness tabs
                    headerView
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .opacity(headerOpacity)
                                .blur(radius: 0.5)
                                .shadow(
                                    color: Color.black.opacity(headerOpacity * 0.2), radius: 10,
                                    x: 0, y: 5
                                )
                                .ignoresSafeArea()
                        )
                }

                Spacer()
            }
        }
        .preferredColorScheme(.dark)
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
                // Chat tab - Placeholder
                placeholderView(title: "Chat", systemImage: "bubble.left.fill")
            } else {
                // Profile tab - Placeholder
                placeholderView(title: "Profile", systemImage: "person.fill")
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
                        width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5
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

    // Header with user info and profile button - now with shrinking animation
    private var headerView: some View {
        HStack(alignment: .center, spacing: 16) {
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                    .opacity(1 - headerOpacity * 0.7)  // Fade out when scrolling

                Text("Nikhil Sharma")
                    .font(.system(size: headerOpacity > 0.8 ? 22 : 28, weight: .bold))  // Shrink text size when scrolling
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: headerOpacity)
            }
            .scaleEffect(x: 1.0, y: headerOpacity > 0.8 ? 0.9 : 1.0, anchor: .leading)  // Shrink vertically

            Spacer()

            // Profile button with glass effect and dynamic sizing
            Button(action: {
                withAnimation {
                    selectedTab = 3  // Switch to Profile tab
                }
            }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.7)
                        .frame(
                            width: headerOpacity > 0.8 ? 44 : 50,
                            height: headerOpacity > 0.8 ? 44 : 50
                        )  // Shrink button when scrolling
                        .shadow(color: Color.glassShadow, radius: 8, x: 0, y: 4)

                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3), Color.white.opacity(0.1),
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.7
                        )
                        .frame(
                            width: headerOpacity > 0.8 ? 44 : 50,
                            height: headerOpacity > 0.8 ? 44 : 50)

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: headerOpacity > 0.8 ? 26 : 30))
                        .foregroundColor(.textPrimary)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: headerOpacity)
            }
            .contentShape(Circle())
            .scaleEffect(isCardPressed ? 0.95 : 1.0)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isCardPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        isCardPressed = false
                    }
                }
            }
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
                .buttonStyle(ScalingButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.7)
                    .background(Color.cardBackground.opacity(0.4))

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
struct ScalingButtonStyle: ButtonStyle {
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
