import SwiftUI

struct WeightDetailView: View {
    // Weight data
    @State private var weightEntries: [WeightEntry] = []
    @State private var isLoading = false
    @State private var isSyncing = false
    @State private var errorMessage: String?
    
    // UI controls
    @State private var selectedTimeRange: TimeRange = .month
    @State private var sortOrder: SortOrder = .newest
    @State private var showSortOptions = false
    @Environment(\.presentationMode) var presentationMode
    
    // Graph animation
    @State private var showGraph = false
    
    // Initialize with optional entries from parent view 
    init(initialEntries: [WeightEntry]? = nil) {
        if let entries = initialEntries {
            _weightEntries = State(initialValue: entries)
        }
    }
    
    enum TimeRange: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case threeMonths = "3 Months"
        case year = "Year"
        case threeYears = "3 Years"
        case lifetime = "Lifetime"
        
        var id: String { self.rawValue }
    }
    
    enum SortOrder: String, CaseIterable, Identifiable {
        case newest = "Newest First"
        case oldest = "Oldest First"
        case highestWeight = "Highest Weight"
        case lowestWeight = "Lowest Weight"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        ZStack {
            // Background with subtle gradient
            backgroundGradient
            
            VStack(spacing: 0) {
                // Custom header
                headerView
                
                // Main content
                ScrollView {
                    VStack(spacing: 24) {
                        // Time range selector
                        timeRangeSelector
                        
                        // Graph section with animations
                        graphSection
                            .opacity(showGraph ? 1 : 0)
                            .offset(y: showGraph ? 0 : 20)
                        
                        // Stats section
                        statsSection
                            .opacity(showGraph ? 1 : 0)
                            .offset(y: showGraph ? 0 : 20)
                        
                        // Entries list with sort controls
                        entriesSection
                            .opacity(showGraph ? 1 : 0)
                            .offset(y: showGraph ? 0 : 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            
            // Error or loading overlay
            if isLoading {
                loadingOverlay
            } else if let error = errorMessage, weightEntries.isEmpty {
                errorOverlay(message: error)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            loadData()
            
            // Animate the graph appearance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showGraph = true
                }
            }
        }
    }
    
    // MARK: - UI Components
    
    private var backgroundGradient: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Radial gradient similar to main view
            VStack {
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.vibrantMint.opacity(0.3),
                        Color.vibrantTeal.opacity(0.15),
                        .clear
                    ]),
                    center: .topTrailing,
                    startRadius: 20,
                    endRadius: 600
                )
                .frame(height: 300)
                .opacity(0.6)
                .blur(radius: 30)
                
                Spacer()
            }
            .ignoresSafeArea()
            
            // Glass-like overlay
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.1)
                .ignoresSafeArea()
        }
    }
    
    private var headerView: some View {
        ZStack {
            // Ultra minimal header background - just a subtle blur
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.4)
                .background(Color.black.opacity(0.2))
                .ignoresSafeArea()
                
            // Header content
            HStack {
                // Simple back button with chevron only
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                // Clean, simple title
                Text("Weight History")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Sync button
                Button(action: {
                    syncWithBackend()
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .rotationEffect(Angle(degrees: isSyncing ? 360 : 0))
                        .animation(
                          isSyncing
                            ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default,
                          value: isSyncing)
                }
                .disabled(isSyncing)
                .padding(.trailing, 8)
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44)
        }
        .frame(height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44) + 32)
    }
    
    private var timeRangeSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Range")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(TimeRange.allCases) { range in
                        Button(action: {
                            withAnimation {
                                selectedTimeRange = range
                            }
                        }) {
                            Text(range.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedTimeRange == range ? .black : .white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedTimeRange == range ? Color.vibrantMint : Color.black.opacity(0.3))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                )
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.top, 8)
    }
    
    private var graphSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section title
            Text("Weight Trend")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            // Enhanced graph card
            ZStack {
                // Background with glass effect
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .opacity(0.2)
                
                // Graph content
                VStack(alignment: .leading, spacing: 16) {
                    // Weight stats
                    if let currentWeight = weightEntries.first?.weight, 
                       let oldestInRange = filteredEntries.last?.weight {
                        HStack {
                            // Current weight
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text("\(String(format: "%.1f", currentWeight))")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("kg")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            
                            Spacer()
                            
                            // Weight change
                            let difference = currentWeight - oldestInRange
                            let isGain = difference >= 0
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Change")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                HStack(spacing: 4) {
                                    Image(systemName: isGain ? "arrow.up" : "arrow.down")
                                        .foregroundColor(isGain ? .red : .green)
                                    
                                    Text("\(String(format: "%.1f", abs(difference))) kg")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(isGain ? .red : .green)
                                }
                            }
                        }
                    }
                    
                    // Enhanced graph
                    if filteredEntries.count > 1 {
                        DetailedLineChart(
                            dataPoints: filteredEntries.reversed().map { $0.weight },
                            dates: filteredEntries.reversed().map { $0.dateObject }
                        )
                        .frame(height: 220)
                    } else {
                        Text("Not enough data for selected time range")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(height: 200)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(20)
            }
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
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                // Average weight
                statCard(
                    title: "Average",
                    value: averageWeight,
                    unit: "kg",
                    icon: "scalemass.fill",
                    color: .vibrantMint
                )
                
                // Highest weight
                statCard(
                    title: "Highest",
                    value: highestWeight,
                    unit: "kg",
                    icon: "arrow.up.forward",
                    color: .accentRed
                )
                
                // Lowest weight
                statCard(
                    title: "Lowest",
                    value: lowestWeight,
                    unit: "kg",
                    icon: "arrow.down.forward",
                    color: .accentGreen
                )
            }
        }
    }
    
    private func statCard(title: String, value: Double, unit: String, icon: String, color: Color) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
            
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text("\(String(format: "%.1f", value))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(unit)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .opacity(0.2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
    }
    
    private var entriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("All Entries")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(sortedEntries.count) records")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Sort options dropdown
            if showSortOptions {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(SortOrder.allCases) { option in
                        Button(action: {
                            withAnimation {
                                sortOrder = option
                                showSortOptions = false
                            }
                        }) {
                            HStack {
                                Text(option.rawValue)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if sortOrder == option {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12))
                                        .foregroundColor(.vibrantMint)
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                        }
                    }
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .opacity(0.3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
                .transition(.scale.combined(with: .opacity))
            }
            
            // List of entries
            LazyVStack(spacing: 0) {
                ForEach(sortedEntries) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.formattedDate)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text(formattedTime(from: entry.date))
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        // Weight
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(String(format: "%.1f", entry.weight))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("kg")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        // Show camera icon if entry has image
                        if entry.image != nil {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.vibrantMint)
                                .padding(.leading, 6)
                        }
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.2))
                            .opacity(0)
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                        .padding(.horizontal, 16)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .opacity(0.15)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .vibrantMint))
                    .scaleEffect(1.5)
                
                Text("Loading weight data...")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
        }
    }
    
    private func errorOverlay(message: String) -> some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                
                Text("Error loading data")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button("Try Again") {
                    loadData()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.vibrantMint)
                .foregroundColor(.black)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Data Processing
    
    private var filteredEntries: [WeightEntry] {
        // Filter entries based on selected time range
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTimeRange {
        case .week:
            let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            return weightEntries.filter { $0.dateObject >= oneWeekAgo }
        case .month:
            let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return weightEntries.filter { $0.dateObject >= oneMonthAgo }
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now)!
            return weightEntries.filter { $0.dateObject >= threeMonthsAgo }
        case .year:
            let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
            return weightEntries.filter { $0.dateObject >= oneYearAgo }
        case .threeYears:
            let threeYearsAgo = calendar.date(byAdding: .year, value: -3, to: now)!
            return weightEntries.filter { $0.dateObject >= threeYearsAgo }
        case .lifetime:
            return weightEntries
        }
    }
    
    private var sortedEntries: [WeightEntry] {
        switch sortOrder {
        case .newest:
            return filteredEntries
        case .oldest:
            return filteredEntries.reversed()
        case .highestWeight:
            return filteredEntries.sorted(by: { $0.weight > $1.weight })
        case .lowestWeight:
            return filteredEntries.sorted(by: { $0.weight < $1.weight })
        }
    }
    
    private var averageWeight: Double {
        guard !filteredEntries.isEmpty else { return 0 }
        let sum = filteredEntries.reduce(0) { $0 + $1.weight }
        return sum / Double(filteredEntries.count)
    }
    
    private var highestWeight: Double {
        filteredEntries.max(by: { $0.weight < $1.weight })?.weight ?? 0
    }
    
    private var lowestWeight: Double {
        filteredEntries.min(by: { $0.weight < $1.weight })?.weight ?? 0
    }
    
    // MARK: - Helper Methods
    
    private func loadData() {
        isLoading = true
        errorMessage = nil
        
        // First load from cache to show something quickly
        if let cachedEntries = CacheService.shared.getCachedWeightData() {
            self.weightEntries = cachedEntries.sorted(by: { $0.dateObject > $1.dateObject })
            isLoading = false
        }
        
        // Then sync with backend for latest data
        syncWithBackend()
    }
    
    private func syncWithBackend() {
        guard !isSyncing else { return }
        
        isSyncing = true
        
        Task {
            do {
                guard let token = CacheService.shared.getToken() else {
                    errorMessage = "No authentication token found"
                    isSyncing = false
                    isLoading = false
                    return
                }
                
                print("Fetching latest weight data from server...")
                let entries = try await NetworkService.shared.fetchWeightData(token: token)
                print("Received \(entries.count) entries from server")
                
                await MainActor.run {
                    // IMPORTANT: Completely replace local data with server data
                    self.weightEntries = entries.sorted(by: { $0.dateObject > $1.dateObject })
                    isLoading = false
                    isSyncing = false
                    
                    // Save to cache - completely overwrite existing cache
                    CacheService.shared.saveWeightData(self.weightEntries)
                    print("Weight cache completely overwritten with server data")
                    
                    // Refresh UI
                    withAnimation {
                        showGraph = true
                    }
                }
            } catch {
                await MainActor.run {
                    if weightEntries.isEmpty {
                        errorMessage = error.localizedDescription
                    }
                    isLoading = false
                    isSyncing = false
                    print("Sync failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func formattedTime(from isoString: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: isoString) else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// Enhanced chart component for the detailed view
struct DetailedLineChart: View {
    let dataPoints: [Double]
    let dates: [Date]
    
    @State private var animationProgress: CGFloat = 0
    @State private var selectedPoint: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            if dataPoints.count > 1 {
                ZStack {
                    // Background grid
                    gridLines(in: geometry)
                    
                    // Date labels
                    dateLabels(in: geometry)
                    
                    // Gradient fill under curve
                    getCurvePath(in: geometry)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.vibrantMint.opacity(0.4),
                                    Color.vibrantTeal.opacity(0.01)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .opacity(animationProgress)
                    
                    // Main curve
                    getCurvePath(in: geometry, closePath: false)
                        .trim(from: 0, to: animationProgress)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.vibrantMint, .vibrantTeal]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                        )
                        .shadow(color: Color.vibrantMint.opacity(0.5), radius: 4, x: 0, y: 2)
                    
                    // Data points with touch interaction
                    ForEach(0..<dataPoints.count, id: \.self) { index in
                        ZStack {
                            // Larger touch area (invisible)
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 44, height: 44)
                                .position(
                                    x: xPosition(for: index, in: geometry),
                                    y: yPosition(for: dataPoints[index], in: geometry)
                                )
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedPoint = (selectedPoint == index) ? nil : index
                                    }
                                }
                            
                            // Outer glow
                            Circle()
                                .fill(Color.vibrantMint.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(selectedPoint == index ? 1.5 : 1.0)
                                .position(
                                    x: xPosition(for: index, in: geometry),
                                    y: yPosition(for: dataPoints[index], in: geometry)
                                )
                            
                            // Inner circle
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
                                .scaleEffect(selectedPoint == index ? 1.3 : 1.0)
                                .position(
                                    x: xPosition(for: index, in: geometry),
                                    y: yPosition(for: dataPoints[index], in: geometry)
                                )
                            
                            // Point value tooltip
                            if selectedPoint == index {
                                VStack(spacing: 4) {
                                    Text("\(String(format: "%.1f", dataPoints[index])) kg")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.black.opacity(0.7))
                                        )
                                    
                                    // Triangle pointer
                                    Triangle()
                                        .fill(Color.black.opacity(0.7))
                                        .frame(width: 10, height: 5)
                                        .rotationEffect(.degrees(180))
                                }
                                .position(
                                    x: xPosition(for: index, in: geometry),
                                    y: yPosition(for: dataPoints[index], in: geometry) - 25
                                )
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .opacity(animationProgress >= CGFloat(index) / CGFloat(dataPoints.count - 1) ? 1 : 0)
                    }
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 1.2)) {
                        animationProgress = 1.0
                    }
                }
            } else {
                Text("Not enough data for chart")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private func dateLabels(in geometry: GeometryProxy) -> some View {
        let labelCount = min(5, dataPoints.count)
        let step = max(1, dataPoints.count / labelCount)
        
        return HStack(spacing: 0) {
            ForEach(0..<dataPoints.count, id: \.self) { index in
                if index % step == 0 || index == dataPoints.count - 1 {
                    Text(formatDate(dates[index]))
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: geometry.size.width / CGFloat(labelCount))
                        .position(
                            x: xPosition(for: index, in: geometry),
                            y: geometry.size.height - 8
                        )
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
    
    private func gridLines(in geometry: GeometryProxy) -> some View {
        let horizontalLines = 5
        
        return VStack(spacing: 0) {
            ForEach(0..<horizontalLines, id: \.self) { index in
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 1)
                
                // Weight value labels on the right side
                if let min = dataPoints.min(), let max = dataPoints.max() {
                    let range = max - min
                    let lineValue = max - (range * CGFloat(index) / CGFloat(horizontalLines - 1))
                    
                    Text("\(String(format: "%.1f", lineValue))")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.5))
                        .frame(width: 24, alignment: .trailing)
                        .position(x: geometry.size.width - 12, y: 0)
                }
            }
            Spacer()
        }
    }
    
    private func getCurvePath(in geometry: GeometryProxy, closePath: Bool = true) -> Path {
        Path { path in
            guard dataPoints.count > 1 else { return }
            
            let points = (0..<dataPoints.count).map { index -> CGPoint in
                CGPoint(
                    x: xPosition(for: index, in: geometry),
                    y: yPosition(for: dataPoints[index], in: geometry)
                )
            }
            
            // Start at the first point
            path.move(to: points[0])
            
            // Draw curved lines between points
            if points.count > 1 {
                for i in 1..<points.count {
                    let previous = points[i-1]
                    let current = points[i]
                    
                    // Calculate control points for the curve
                    let controlPoint1 = CGPoint(
                        x: previous.x + (current.x - previous.x) / 2,
                        y: previous.y
                    )
                    
                    let controlPoint2 = CGPoint(
                        x: previous.x + (current.x - previous.x) / 2,
                        y: current.y
                    )
                    
                    // Add the curve
                    path.addCurve(to: current, control1: controlPoint1, control2: controlPoint2)
                }
            }
            
            // If we're creating the fill path, close the path at the bottom
            if closePath {
                // Go to the bottom right
                path.addLine(to: CGPoint(
                    x: xPosition(for: dataPoints.count - 1, in: geometry),
                    y: geometry.size.height - 20 // Leave room for date labels
                ))
                
                // Go to the bottom left
                path.addLine(to: CGPoint(
                    x: xPosition(for: 0, in: geometry),
                    y: geometry.size.height - 20 // Leave room for date labels
                ))
                
                // Close the path
                path.closeSubpath()
            }
        }
    }
    
    private func xPosition(for index: Int, in geometry: GeometryProxy) -> CGFloat {
        guard dataPoints.count > 1 else { return 0 }
        let width = geometry.size.width - 30 // Account for label spacing on right
        let segmentWidth = width / CGFloat(dataPoints.count - 1)
        return CGFloat(index) * segmentWidth
    }
    
    private func yPosition(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        guard let min = dataPoints.min(), let max = dataPoints.max() else { return 0 }
        if min == max { return geometry.size.height / 2 }  // Avoid division by zero
        
        let padding: CGFloat = 30 // Top and bottom padding for the graph
        let availableHeight = geometry.size.height - padding * 2 - 20 // Account for date labels
        let normalizedValue = CGFloat((value - min) / (max - min))
        return geometry.size.height - (normalizedValue * availableHeight + padding) - 20
    }
}

// Helper shape for the tooltip pointer
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// Preview
#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        WeightDetailView()
    }
} 