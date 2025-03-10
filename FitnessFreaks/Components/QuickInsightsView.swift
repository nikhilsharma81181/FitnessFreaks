import SwiftUI

// File: QuickInsightsView.swift
// Path: /FitnessFreaks/Components/QuickInsightsView.swift

struct QuickInsightsView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Header with balanced spacing
            HStack {
                Text("Quick Insights")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color.vibrantMint)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(Color.vibrantMint)
                    }
                }
            }
            .padding(.horizontal, 4)
            
            // Stats cards with improved layout
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                // Heart Rate card
                insightCard(
                    icon: "heart.fill",
                    iconColor: .accentRed,
                    bgColor: Color(red: 0.45, green: 0.15, blue: 0.15),
                    title: "Heart Rate",
                    value: "68",
                    unit: "bpm",
                    trend: "+2",
                    trendUp: true
                )
                
                // Sleep card
                insightCard(
                    icon: "moon.fill",
                    iconColor: .sleepTeal,
                    bgColor: Color(red: 0.15, green: 0.35, blue: 0.35),
                    title: "Sleep",
                    value: "7.5",
                    unit: "hrs",
                    trend: "+0.4",
                    trendUp: true
                )
                
                // Recovery card
                insightCard(
                    icon: "battery.75.fill",
                    iconColor: .recoveryGreen,
                    bgColor: Color(red: 0.15, green: 0.35, blue: 0.2),
                    title: "Recovery",
                    value: "85",
                    unit: "%",
                    trend: "+12",
                    trendUp: true
                )
                
                // Stress card
                insightCard(
                    icon: "waveform.path",
                    iconColor: .stressBlue,
                    bgColor: Color(red: 0.15, green: 0.2, blue: 0.45),
                    title: "Stress",
                    value: "Low",
                    unit: "",
                    trend: "-5",
                    trendUp: false
                )
            }
        }
    }
    
    // Enhanced card design with better spacing, balance and trend indicators
    private func insightCard(icon: String, iconColor: Color, bgColor: Color, title: String, value: String, unit: String, trend: String, trendUp: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top row with icon and trend
            HStack {
                // Icon with improved styling
                ZStack {
                    Circle()
                        .fill(bgColor.opacity(0.4))
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                Spacer()
                
                // Trend indicator
                if !trend.isEmpty {
                    HStack(spacing: 2) {
                        Image(systemName: trendUp ? "arrow.up" : "arrow.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(trendUp ? .accentGreen : .accentRed)
                        
                        Text(trend)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(trendUp ? .accentGreen : .accentRed)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(trendUp ? Color.accentGreen.opacity(0.15) : Color.accentRed.opacity(0.15))
                    )
                }
            }
            .padding(.bottom, 12)
            
            // Title with proper spacing
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .padding(.bottom, 6)
            
            // Value and unit with better alignment
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.leading, 1)
                        .offset(y: 2)
                }
            }
            
            Spacer()
        }
        .frame(height: 140)
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(
            ZStack {
                // Beautiful card background with subtle gradient
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.3))
                
                // Ultra thin material for glass effect
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .opacity(0.6)
                
                // Subtle gradient overlay for depth
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    bgColor.opacity(0.15),
                                    bgColor.opacity(0.05)
                                ]
                            ),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.overlay)
                
                // Refined border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color.white.opacity(0.12),
                                    Color.white.opacity(0.03)
                                ]
                            ),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
        )
    }
}

// Preview with the background gradient
struct QuickInsightsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundGradient()
            
            QuickInsightsView()
                .padding(20)
        }
    }
}