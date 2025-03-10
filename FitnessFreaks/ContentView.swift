import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    private let tabItems = ["Activity", "Recovery", "Sleep", "Metrics"]
    private let tabIcons = ["figure.run", "heart.fill", "moon.fill", "chart.bar.fill"]
    
    var body: some View {
        ZStack {
            // Background with vibrant mint/teal gradient
            backgroundLayers
            
            VStack {
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with user info
                        headerView
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        
                        // Main card - WorkoutProgressCard
                        WorkoutProgressCard()
                            .padding(.horizontal, 24)
                        
                        // Quick stats cards
                        quickStatsView
                            .padding(.horizontal, 24)
                        
                        // Bottom spacing
                        Spacer()
                            .frame(height: 90) // Space for tab bar
                    }
                    .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)
                
                // Custom tab bar
                customTabBar
            }
        }
        .preferredColorScheme(.dark)
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
                        gradient: Gradient(colors: [.vibrantMint, .vibrantTeal.opacity(0.5), .clear]),
                        center: .topTrailing,
                        startRadius: 20,
                        endRadius: 600
                    )
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                    .opacity(0.45)
                    .blur(radius: 40) // Soft blur for frosted effect
                    
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
    
    // Header with user info and profile button
    private var headerView: some View {
        HStack(alignment: .center, spacing: 16) {
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                Text("Nikhil Sharma")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            // Profile button with glass effect
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.7)
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.glassShadow, radius: 8, x: 0, y: 4)
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.7
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }
    
    // Quick stats view
    private var quickStatsView: some View {
        VStack(spacing: 16) {
            // Section title
            HStack {
                Text("Quick Insights")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.accentGreen)
                }
            }
            
            // Stats cards
            HStack(spacing: 16) {
                // Heart rate card
                statCard(
                    title: "Heart Rate",
                    value: "68",
                    unit: "bpm",
                    icon: "heart.fill",
                    color: .accentRed
                )
                
                // Sleep card
                statCard(
                    title: "Sleep",
                    value: "7.5",
                    unit: "hrs",
                    icon: "moon.fill",
                    color: .sleepTeal
                )
            }
            
            HStack(spacing: 16) {
                // Recovery card
                statCard(
                    title: "Recovery",
                    value: "85",
                    unit: "%",
                    icon: "battery.75",
                    color: .recoveryGreen
                )
                
                // Stress card
                statCard(
                    title: "Stress",
                    value: "Low",
                    unit: "",
                    icon: "waveform.path",
                    color: .stressBlue
                )
            }
        }
    }
    
    // Helper function to create stat cards
    private func statCard(title: String, value: String, unit: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
            }
            
            // Title
            Text(title)
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            // Value
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.textSecondary)
                    .padding(.leading, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .opacity(0.5)
                .background(Color.cardBackgroundAlt.opacity(0.4))
                .cornerRadius(18)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.7
                )
        )
    }
    
    // Custom tab bar with glass effect
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabItems.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabIcons[index])
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == index ? .accentGreen : .textSecondary)
                        
                        Text(tabItems[index])
                            .font(.caption2)
                            .foregroundColor(selectedTab == index ? .textPrimary : .textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
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
                            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
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

#Preview {
    ContentView()
}
