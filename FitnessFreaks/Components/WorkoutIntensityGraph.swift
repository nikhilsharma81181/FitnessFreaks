import SwiftUI

// File: WorkoutIntensityGraph.swift
// Path: /FitnessFreaks/Components/WorkoutIntensityGraph.swift

struct WorkoutIntensityGraph: View {
    // Sample data for different time periods
    let weeklyData: [IntensityPoint] = [
        IntensityPoint(day: "Mon", value: 65, label: "Running"),
        IntensityPoint(day: "Tue", value: 82, label: "HIIT"),
        IntensityPoint(day: "Wed", value: 45, label: "Recovery"),
        IntensityPoint(day: "Thu", value: 75, label: "Strength"),
        IntensityPoint(day: "Fri", value: 92, label: "CrossFit"),
        IntensityPoint(day: "Sat", value: 60, label: "Cycling"),
        IntensityPoint(day: "Sun", value: 30, label: "Rest Day")
    ]
    
    let monthlyData: [IntensityPoint] = [
        IntensityPoint(day: "W1", value: 70, label: "Week 1"),
        IntensityPoint(day: "W2", value: 78, label: "Week 2"),
        IntensityPoint(day: "W3", value: 85, label: "Week 3"),
        IntensityPoint(day: "W4", value: 75, label: "Week 4")
    ]
    
    @State private var selectedTimeframe: Timeframe = .week
    @State private var currentDataPoints: [IntensityPoint] = []
    @State private var showGraph: Bool = false
    @State private var selectedPoint: IntensityPoint? = nil
    
    // Animation properties
    @State private var lineProgress: CGFloat = 0
    @State private var pointsAppear: Bool = false
    
    enum Timeframe: String, CaseIterable {
        case week = "Week"
        case month = "Month"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with timeframe selector
            HStack {
                Text("Workout Intensity")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Timeframe picker with pill-style segmented control
                timeframePickerView
            }
            
            // Graph view with animations
            graphContainerView
        }
    }
    
    // Extracted timeframe picker to reduce complexity
    private var timeframePickerView: some View {
        HStack(spacing: 0) {
            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                timeframeButton(for: timeframe)
            }
        }
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .opacity(0.3)
        )
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
    }
    
    // Extract individual timeframe button
    private func timeframeButton(for timeframe: Timeframe) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTimeframe = timeframe
                resetAnimations()
                
                // Update data based on timeframe
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    currentDataPoints = timeframe == .week ? weeklyData : monthlyData
                    animateGraph()
                }
            }
        }) {
            Text(timeframe.rawValue)
                .font(.system(size: 14, weight: selectedTimeframe == timeframe ? .semibold : .medium))
                .foregroundColor(selectedTimeframe == timeframe ? .white : .white.opacity(0.6))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(timeframeButtonBackground(for: timeframe))
        }
    }
    
    // Extract timeframe button background
    private func timeframeButtonBackground(for timeframe: Timeframe) -> some View {
        Group {
            if selectedTimeframe == timeframe {
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.accentOrange, Color.accentRed]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            } else {
                Color.clear
            }
        }
    }
    
    // Extracted graph container to reduce complexity
    private var graphContainerView: some View {
        ZStack {
            // Background grid lines
            VStack(spacing: 0) {
                ForEach(0..<4) { i in
                    Divider()
                        .background(Color.white.opacity(0.1))
                        .offset(y: i == 0 ? 0 : CGFloat(i) * 50)
                }
                Spacer()
            }
            .frame(height: 200)
            
            // Line graph
            lineGraph
                .padding(.top, 25)
                .animation(.easeOut(duration: 0.7), value: currentDataPoints)
            
            // Selection detail popup
            selectionPopupView
        }
        .frame(height: 250)
        .background(graphBackground)
        .onAppear {
            // Initialize with weekly data
            currentDataPoints = weeklyData
            animateGraph()
        }
    }
    
    // Extract selection popup view
    private var selectionPopupView: some View {
        Group {
            if let selectedPoint = selectedPoint {
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedPoint.label)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Intensity:")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("\(Int(selectedPoint.value))%")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.accentOrange)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .opacity(0.9)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
                .offset(x: getPopupOffsetX(for: selectedPoint), y: -70)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                .zIndex(1)
            }
        }
    }
    
    // Extract graph background
    private var graphBackground: some View {
        ZStack {
            // Background with glass effect
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.2))
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .opacity(0.6)
            
            // Subtle gradient overlay for depth
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color(red: 0.45, green: 0.15, blue: 0.15).opacity(0.1),
                                Color.clear
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
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
    }
    
    // Line graph view with curve and animations
    private var lineGraph: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let maxValue = currentDataPoints.map { $0.value }.max() ?? 100
            let points = currentDataPoints.enumerated().map { index, point -> CGPoint in
                let x = width * CGFloat(index) / CGFloat(currentDataPoints.count - 1)
                let y = height - (height * CGFloat(point.value) / CGFloat(maxValue))
                return CGPoint(x: x, y: y)
            }
            
            ZStack {
                // Gradient area fill under the curve
                gradientAreaView(points: points, size: geo.size)
                
                // The curve itself
                curveLineView(points: points)
                
                // Data points
                dataPointsView(points: points)
                
                // Day labels
                dayLabelsView(width: width)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    // Extract gradient area view
    private func gradientAreaView(points: [CGPoint], size: CGSize) -> some View {
        Group {
            if showGraph && !points.isEmpty {
                getGradientPath(for: points, in: size)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color.accentRed.opacity(0.5),
                                    Color.accentOrange.opacity(0.1),
                                    Color.clear
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(lineProgress)
            }
        }
    }
    
    // Extract curve line view
    private func curveLineView(points: [CGPoint]) -> some View {
        Group {
            if showGraph && !points.isEmpty {
                getCurvePath(for: points)
                    .trim(from: 0, to: lineProgress)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color.accentRed,
                                    Color.accentOrange
                                ]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                    .shadow(color: Color.accentRed.opacity(0.3), radius: 6, x: 0, y: 3)
            }
        }
    }
    
    // Extract data points view
    private func dataPointsView(points: [CGPoint]) -> some View {
        Group {
            if pointsAppear {
                ForEach(currentDataPoints.indices, id: \.self) { index in
                    let point = points[index]
                    let dataPoint = currentDataPoints[index]
                    
                    ZStack {
                        // Outer circle with pulsing animation
                        Circle()
                            .fill(Color.accentOrange.opacity(0.5))
                            .frame(width: 18, height: 18)
                            .scaleEffect(selectedPoint?.day == dataPoint.day ? 1.3 : 1.0)
                            .opacity(selectedPoint?.day == dataPoint.day ? 0.7 : 0)
                        
                        // Inner circle
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.accentRed, .accentOrange]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 10, height: 10)
                            .shadow(color: Color.accentRed.opacity(0.5), radius: 3, x: 0, y: 2)
                        
                        // Highlight ring
                        Circle()
                            .stroke(Color.white.opacity(0.8), lineWidth: 2)
                            .frame(width: 10, height: 10)
                            .scaleEffect(selectedPoint?.day == dataPoint.day ? 1.3 : 0.01)
                            .opacity(selectedPoint?.day == dataPoint.day ? 1.0 : 0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedPoint?.day)
                    }
                    .position(point)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if selectedPoint?.day == dataPoint.day {
                                selectedPoint = nil
                            } else {
                                selectedPoint = dataPoint
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Extract day labels view
    private func dayLabelsView(width: CGFloat) -> some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                ForEach(currentDataPoints.indices, id: \.self) { index in
                    Text(currentDataPoints[index].day)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: width / CGFloat(currentDataPoints.count))
                }
            }
            .padding(.top, 8)
        }
    }
    
    // Calculate curve path using Catmull-Rom spline for smoother curve
    private func getCurvePath(for points: [CGPoint]) -> Path {
        Path { path in
            guard points.count > 1 else { return }
            
            // Move to first point
            path.move(to: points[0])
            
            // Draw curves between points
            for i in 1..<points.count {
                let previous = i > 1 ? points[i-2] : points[0]
                let current = points[i-1]
                let next = points[i]
                let after = i < points.count - 1 ? points[i+1] : next
                
                // Calculate control points for smoother curve
                let controlPoint1 = CGPoint(
                    x: current.x + (next.x - previous.x) / 6,
                    y: current.y + (next.y - previous.y) / 6
                )
                
                let controlPoint2 = CGPoint(
                    x: next.x - (after.x - current.x) / 6,
                    y: next.y - (after.y - current.y) / 6
                )
                
                path.addCurve(to: next, control1: controlPoint1, control2: controlPoint2)
            }
        }
    }
    
    // Get the gradient area path under the curve
    private func getGradientPath(for points: [CGPoint], in size: CGSize) -> Path {
        Path { path in
            // Start at bottom-left
            path.move(to: CGPoint(x: 0, y: size.height))
            
            // Draw line to first point
            path.addLine(to: points[0])
            
            // Draw the curve
            for i in 1..<points.count {
                let previous = i > 1 ? points[i-2] : points[0]
                let current = points[i-1]
                let next = points[i]
                let after = i < points.count - 1 ? points[i+1] : next
                
                let controlPoint1 = CGPoint(
                    x: current.x + (next.x - previous.x) / 6,
                    y: current.y + (next.y - previous.y) / 6
                )
                
                let controlPoint2 = CGPoint(
                    x: next.x - (after.x - current.x) / 6,
                    y: next.y - (after.y - current.y) / 6
                )
                
                path.addCurve(to: next, control1: controlPoint1, control2: controlPoint2)
            }
            
            // Complete the path to create a closed shape
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.closeSubpath()
        }
    }
    
    // Calculate popup position to keep it within view bounds
    private func getPopupOffsetX(for point: IntensityPoint) -> CGFloat {
        guard let index = currentDataPoints.firstIndex(where: { $0.day == point.day }) else { return 0 }
        
        let position = Double(index) / Double(currentDataPoints.count - 1)
        
        // Adjust position to keep popup in view
        if position < 0.2 {
            return 40
        } else if position > 0.8 {
            return -40
        } else {
            return 0
        }
    }
    
    // Reset and trigger animations
    private func animateGraph() {
        showGraph = false
        pointsAppear = false
        lineProgress = 0
        
        withAnimation(.easeOut(duration: 0.1)) {
            showGraph = true
        }
        
        // Animate line drawing
        withAnimation(.easeOut(duration: 1.5).delay(0.2)) {
            lineProgress = 1.0
        }
        
        // Animate points appearance
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                pointsAppear = true
            }
        }
    }
    
    // Reset animations when changing timeframe
    private func resetAnimations() {
        selectedPoint = nil
        withAnimation(.easeInOut(duration: 0.3)) {
            showGraph = false
            pointsAppear = false
            lineProgress = 0
        }
    }
}

// Data model for intensity points
struct IntensityPoint: Identifiable, Equatable {
    var id = UUID()
    let day: String
    let value: CGFloat // 0-100 scale
    let label: String
}

// Preview
struct WorkoutIntensityGraph_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundGradient()
            
            WorkoutIntensityGraph()
                .padding(20)
        }
    }
}

// Note: You need to have a BackgroundGradient view and Color extensions for .accentOrange and .accentRed