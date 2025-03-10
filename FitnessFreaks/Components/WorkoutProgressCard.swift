import SwiftUI

// File: WorkoutProgressCard.swift
// Path: /YourProjectName/Views/Components/WorkoutProgressCard.swift

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
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Workout Activity")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
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
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .opacity(0.3) // More transparent
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
                }
            }

            // Week day indicators with enhanced styling
            HStack(spacing: 8) {
                ForEach(0..<7) { index in
                    let day = currentDay - 3 + index // Example calculation
                    VStack(spacing: 6) {
                        Text(weekDays[index])
                            .font(.caption)
                            .foregroundColor(activeWorkoutDays.contains(day) ? .white : .white.opacity(0.5))
                        
                        Text("\(day)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(width: 40, height: 64)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(activeWorkoutDays.contains(day) ? 
                                  Color.vibrantMint.opacity(0.25) : 
                                  Color.black.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(activeWorkoutDays.contains(day) ? 
                                            Color.vibrantMint.opacity(0.7) : 
                                            Color.clear, lineWidth: 1.5)
                            )
                    )
                }
            }
            .padding(.vertical, 4)
            
           
            
            // Previous weeks indicator
            HStack(spacing: 4) {
                Text("Previous Weeks")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.trailing, 10)
                
                ForEach(0..<12) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.vibrantMint.opacity(0.7), 
                                        Color.vibrantMint
                                    ]
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
        .glassCard(cornerRadius: 28, transparency: 0.8) // More transparent glass
    }
}

#Preview {
    ZStack {
        BackgroundGradient()
        
        WorkoutProgressCard()
            .padding()
    }
}
