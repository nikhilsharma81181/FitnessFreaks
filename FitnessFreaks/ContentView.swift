import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    private let tabItems = ["Activity", "Recovery", "Sleep", "Metrics"]
    private let tabIcons = ["figure.run", "heart.fill", "moon.fill", "chart.bar.fill"]
    
    var body: some View {
        ZStack {
            // Enhanced background layers
            backgroundLayers
            
            VStack {
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with user info
                        headerView
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        
                        // Main card - enhanced WorkoutProgressCard
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
    
    // Enhanced background gradient layers
    private var backgroundLayers: some View {
        ZStack {
            // Pure black background
            Color.darkBackground
                .ignoresSafeArea()
            
            // Enhanced gradient blobs
            ZStack {
                // Purple gradient blob
                RadialGradient(
                    gradient: Gradient(colors: [.gradientPurple, .clear]),
                    center: .topLeading,
                    startRadius: 50,
                    endRadius: 700
                )
                .opacity(0.6)
                
                // Green gradient blob
                RadialGradient(
                    gradient: Gradient(colors: [.gradientGreen, .clear]),
                    center: .bottom,
                    startRadius: 50,
                    endRadius: 500
                )
                .opacity(0.4)
                
                // Red gradient blob
                RadialGradient(
                    gradient: Gradient(colors: [.gradientRed, .clear]),
                    center: .topTrailing,
                    startRadius: 50,
                    endRadius: 600
                )
                .opacity(0.6)
            }
            .ignoresSafeArea()
            
            // Ultra thin material blur for glass effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.2)
                .ignoresSafeArea()
        }
    }
    
    // Enhanced header with user info and profile button
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
            
            // Enhanced profile button with glass effect
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color.cardBackground.opacity(0.5))
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.glassShadow, radius: 10, x: 0, y: 5)
                    
                    Circle()
                        .stroke(Color.glassBorder, lineWidth: 1)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }
    
    // New quick stats cards section
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
                .fill(Color.cardBackgroundAlt.opacity(0.6))
        )
        .glassBorder(cornerRadius: 18)
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
                    .fill(Color.cardBackground.opacity(0.95))
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.5)
                
                // Top border
                Rectangle()
                    .fill(Color.glassBorder)
                    .frame(height: 1)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea()
        )
    }
}

#Preview {
    ContentView()
}
