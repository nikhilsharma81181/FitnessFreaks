import SwiftUI

struct DietTrackingView: View {
    @State private var dietEntries: [DietEntry] = DietEntry.mockData
    @State private var showCamera = false
    @State private var showDetailView = false
    @State private var capturedImage: UIImage?
    @State private var showGraph = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title and Add button
            HStack {
                Text("Diet Tracking")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Modern camera button with animation
                Button(action: {
                    showCamera = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16))
                        Text("Add")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.accentGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .stroke(Color.accentGreen.opacity(0.7), lineWidth: 1.5)
                            .background(Color.accentGreen.opacity(0.1))
                            .clipShape(Capsule())
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Diet nutrition summary
            nutritionSummary
                .opacity(showGraph ? 1 : 0)
                .offset(y: showGraph ? 0 : 20)
            
            // Nutrition distribution chart
            nutritionChart
                .opacity(showGraph ? 1 : 0)
                .offset(y: showGraph ? 0 : 20)
            
            // Recent entries list
            recentEntriesList
                .opacity(showGraph ? 1 : 0)
                .offset(y: showGraph ? 0 : 20)
            
            // View All Data button
            Button(action: {
                showDetailView = true
            }) {
                HStack {
                    Text("View All Meals")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.accentGreen)
                )
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .opacity(showGraph ? 1 : 0)
            .offset(y: showGraph ? 0 : 20)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .opacity(0.2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.05),
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        )
        .fullScreenCover(isPresented: $showDetailView) {
            DietDetailView(initialEntries: dietEntries)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showGraph = true
            }
        }
    }
    
    private var nutritionSummary: some View {
        HStack(spacing: 20) {
            // Today's calories
            VStack(alignment: .center, spacing: 4) {
                Text("Today")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("1,850")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("cal")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.25))
            )
            
            // Progress to goal
            VStack(alignment: .center, spacing: 4) {
                Text("Progress")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("85%")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.25))
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var nutritionChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Macro Distribution")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            HStack(spacing: 12) {
                // Protein bar
                macroBar(
                    macroName: "Protein",
                    value: 100,
                    targetValue: 140,
                    color: .accentBlue
                )
                
                // Carbs bar
                macroBar(
                    macroName: "Carbs",
                    value: 140,
                    targetValue: 180,
                    color: .accentGreen
                )
                
                // Fat bar
                macroBar(
                    macroName: "Fat",
                    value: 65,
                    targetValue: 70,
                    color: .accentOrange
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func macroBar(macroName: String, value: Int, targetValue: Int, color: Color) -> some View {
        let progress = min(CGFloat(value) / CGFloat(targetValue), 1.0)
        
        return VStack(alignment: .leading, spacing: 8) {
            // Macro name and value
            HStack {
                Text(macroName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(value)g")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Progress bar
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 36)
                
                // Filled portion
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, progress * (UIScreen.main.bounds.width - 100) / 3), height: 36)
            }
            
            // Target
            Text("Target: \(targetValue)g")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var recentEntriesList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Meals")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            // Recent entries (show up to 3 most recent)
            ForEach(Array(dietEntries.prefix(3))) { entry in
                HStack {
                    // Meal type indicator
                    Circle()
                        .fill(mealTypeColor(entry.mealType))
                        .frame(width: 8, height: 8)
                    
                    Text(entry.mealType)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 70, alignment: .leading)
                    
                    Text("\(entry.calories) cal")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Show camera icon if entry has image
                    if entry.image != nil {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.accentGreen)
                            .padding(.trailing, 4)
                    }
                    
                    Text(entry.shortDate)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                
                if entry.id != dietEntries.prefix(3).last?.id {
                    Divider()
                        .background(Color.white.opacity(0.1))
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    // Helper to determine color based on meal type
    private func mealTypeColor(_ mealType: String) -> Color {
        switch mealType {
        case "Breakfast":
            return .accentOrange
        case "Lunch":
            return .accentGreen
        case "Dinner":
            return .accentBlue
        case "Snack":
            return .accentPurple
        default:
            return .accentGreen
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        DietTrackingView()
            .padding()
    }
} 