import SwiftUI

// File: GraphMetricsView.swift
// Path: /FitnessFreaks/Components/GraphMetricsView.swift

struct GraphMetricsView: View {
    // Sample data for the graphs
    let heartRateData: [CGFloat] = [65, 68, 72, 78, 68, 65, 62, 64, 68, 70, 68, 65]
    let sleepData: [CGFloat] = [7.5, 6.8, 7.2, 8.1, 6.5, 7.0, 7.8]
    let calorieData: [CGFloat] = [350, 420, 380, 450, 510, 420, 400]
    let activeMinutes: [CGFloat] = [45, 60, 30, 75, 65, 40, 55]
    
    // Selected time period
    @State private var selectedPeriod = "Week"
    let periods = ["Day", "Week", "Month", "Year"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with period selector
            HStack {
                Text("Activity Metrics")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Period picker with glass effect
                Menu {
                    ForEach(periods, id: \.self) { period in
                        Button(period) {
                            selectedPeriod = period
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedPeriod)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .opacity(0.5)
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
                }
            }
            
            // Metrics graphs in a scrollable horizontal container
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Heart Rate Graph
                    metricGraphCard(
                        title: "Heart Rate",
                        value: "68",
                        unit: "bpm",
                        color: .accentRed,
                        icon: "heart.fill",
                        data: heartRateData
                    )
                    
                    // Active Minutes Graph
                    metricGraphCard(
                        title: "Active Minutes",
                        value: "55",
                        unit: "min",
                        color: .accentGreen,
                        icon: "flame.fill",
                        data: activeMinutes
                    )
                    
                    // Calories Graph
                    metricGraphCard(
                        title: "Calories",
                        value: "420",
                        unit: "kcal",
                        color: .accentOrange,
                        icon: "bolt.fill",
                        data: calorieData
                    )
                    
                    // Sleep Graph
                    metricGraphCard(
                        title: "Sleep",
                        value: "7.5",
                        unit: "hrs",
                        color: .sleepTeal,
                        icon: "moon.fill",
                        data: sleepData
                    )
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 8)
            }
        }
    }
    
    // Metric card with graph component
    private func metricGraphCard(title: String, value: String, unit: String, color: Color, icon: String, data: [CGFloat]) -> some View {
        let maxValue = data.max() ?? 1
        
        return VStack(alignment: .leading, spacing: 14) {
            // Icon and title row
            HStack {
                // Icon with colored background
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }
                
                // Title
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
            }
            
            // Value display
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text(unit)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.leading, 2)
            }
            
            // Graph
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<data.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(0.7),
                                    color
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: 9, height: 70 * (data[index] / maxValue))
                }
            }
            .frame(height: 70, alignment: .bottom)
            .padding(.top, 4)
            
            // Day indicators
            HStack(spacing: 4) {
                ForEach(0..<data.count, id: \.self) { index in
                    if selectedPeriod == "Week" {
                        Text(["M", "T", "W", "T", "F", "S", "S"][index % 7])
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(width: 9)
                    } else {
                        Text("\(index + 1)")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(width: 9)
                    }
                }
            }
        }
        .padding(16)
        .frame(width: 220, height: 250)
        .background(
            ZStack {
                // Background with glass effect
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .opacity(0.6)
                
                // Subtle color overlay
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    color.opacity(0.15),
                                    color.opacity(0.05)
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

// Preview
struct GraphMetricsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundGradient()
            
            GraphMetricsView()
                .padding(20)
        }
    }
} 