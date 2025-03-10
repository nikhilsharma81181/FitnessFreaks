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
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.cardBackground.opacity(0.6))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.glassBorder, lineWidth: 1)
                    )
                }
            }
            
            // Week day indicators
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
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(activeWorkoutDays.contains(day) ? Color.accentGreen.opacity(0.3) : Color.cardBackground.opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(activeWorkoutDays.contains(day) ? Color.accentGreen : Color.clear, lineWidth: 1.5)
                            )
                    )
                }
            }
            .padding(.vertical, 4)
            
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
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.cardBackground)
                
                // Subtle gradient overlay
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.accentGreen.opacity(0.1), Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.overlay)
                
                // Glass effect border
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.glassBorder, lineWidth: 1)
            }
        )
        .shadow(color: Color.glassShadow, radius: 15, x: 0, y: 10)
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
