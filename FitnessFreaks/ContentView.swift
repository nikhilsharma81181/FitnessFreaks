import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background layers
            backgroundLayers
            
            // Content
            ScrollView {
                VStack(spacing: 24) {
                    // Header with user info
                    headerView
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    // Main card - only WorkoutProgressCard
                    WorkoutProgressCard()
                        .padding(.horizontal, 24)
                    
                    // Bottom spacing
                    Spacer()
                        .frame(height: 30)
                }
                .padding(.vertical, 8)
            }
            .scrollIndicators(.hidden)
        }
        .preferredColorScheme(.dark)
    }
    
    // Background gradient layers
    private var backgroundLayers: some View {
        ZStack {
            // Pure black background
            Color.darkBackground
                .ignoresSafeArea()
            
            // Gradient blobs
            ZStack {
                // Purple gradient blob
                RadialGradient(
                    gradient: Gradient(colors: [.gradientPurple, .clear]),
                    center: .topLeading,
                    startRadius: 50,
                    endRadius: 500
                )
                .opacity(0.7)
                
                // Red gradient blob
                RadialGradient(
                    gradient: Gradient(colors: [.gradientRed, .clear]),
                    center: .topTrailing,
                    startRadius: 50,
                    endRadius: 500
                )
                .opacity(0.7)
            }
            .ignoresSafeArea()
            
            // Ultra thin material blur for glass effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.2)
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
                        .fill(Color.cardBackground.opacity(0.5))
                        .frame(width: 46, height: 46)
                        .shadow(color: Color.glassShadow, radius: 10, x: 0, y: 5)
                    
                    Circle()
                        .stroke(Color.glassBorder, lineWidth: 1)
                        .frame(width: 46, height: 46)
                    
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}