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
            
           
            
            // Previous weeks indicator
            HStack(spacing: 4) {
                Text("Previous Weeks")
                    .font(.subheadline)
                    .foregroundColor(.textTertiary)
                    .padding(.trailing, 10)
                
                ForEach(0..<12) { index in
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
                        .frame(width: 12, height: 8)
                }
                
                Spacer()
            }
            .padding(.top, 4)
            
            
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
