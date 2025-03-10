import SwiftUI

struct WorkoutProgressCard: View {
    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    let currentDay = 10 // Example value
    let activeWorkoutDays = [10, 12, 14, 15] // Example active days
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monday, Mar \(currentDay)")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text("Workout Activity")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                Menu {
                    Button("This Week", action: {})
                    Button("Last Week", action: {})
                    Button("This Month", action: {})
                } label: {
                    HStack(spacing: 4) {
                        Text("This Week")
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .glassButtonStyle(accentColor: .accentGreen)
                }
            }
            
            // Score indicator
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Activity Score")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Text("85")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.accentGreen)
                }
                
                Spacer()
                
                // Small progress indicator
                ZStack {
                    Circle()
                        .stroke(Color.cardBackgroundAlt, lineWidth: 4)
                        .frame(width: 48, height: 48)
                    
                    Circle()
                        .trim(from: 0, to: 0.85)
                        .stroke(Color.accentGreen, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.cardBackgroundAlt.opacity(0.6))
            )
            .glassBorder(cornerRadius: 18)
            
            // Week day indicators with enhanced styling
            HStack(spacing: 12) {
                ForEach(0..<7) { index in
                    let day = currentDay - 3 + index // Example calculation
                    VStack(spacing: 6) {
                        Text(weekDays[index])
                            .font(.caption)
                            .foregroundColor(activeWorkoutDays.contains(day) ? .textPrimary : .textTertiary)
                        
                        Text("\(day)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textPrimary)
                    }
                    .frame(width: 36, height: 64)
                    .metricIndicatorStyle(isActive: activeWorkoutDays.contains(day), accentColor: .accentGreen)
                }
            }
            .padding(.vertical, 4)
            
            // Activity breakdown section
            VStack(alignment: .leading, spacing: 15) {
                Text("Activity Breakdown")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                // Activity metrics
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("4,250")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Steps")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1.8 km")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Distance")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("245")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Calories")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Simplified bar chart
                HStack(spacing: 5) {
                    ForEach(0..<7) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [Color.accentGreen.opacity(0.5), Color.accentGreen]
                                    ),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: 12, height: CGFloat(30 + index * 5))
                    }
                }
                .frame(height: 70)
                .padding(.top, 5)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.cardBackgroundAlt.opacity(0.6))
            )
            .glassBorder(cornerRadius: 18)
            
            // Previous weeks indicator
            HStack(spacing: 5) {
                Text("Previous Weeks")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                    .padding(.trailing, 4)
                
                ForEach(0..<12) { index in
                    Circle()
                        .fill(index % 2 == 0 ? Color.accentGreen : Color.accentGreen.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
                
                Spacer()
            }
            .padding(.top, 4)
            
            // Intensity indicator
            HStack(spacing: 6) {
                Text("Less")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                HStack(spacing: 3) {
                    ForEach(0..<3) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [Color.accentGreen.opacity(0.7), Color.accentGreen]
                                    ),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 24, height: 8)
                    }
                }
                
                Text("More")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                
                Spacer()
            }
        }
        .padding(24)
        .glassCardStyle(cornerRadius: 28)
    }
}

#Preview {
    ZStack {
        Color.darkBackground
            .ignoresSafeArea()
        WorkoutProgressCard()
            .padding()
    }
}
