import SwiftUI

struct DietDetailView: View {
    // Diet data
    @State private var dietEntries: [DietEntry]
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // UI controls
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedMealType: MealTypeFilter = .all
    @State private var sortOrder: SortOrder = .newest
    @State private var showSortOptions = false
    @Environment(\.presentationMode) var presentationMode
    
    // Graph animation
    @State private var showContent = false
    
    // Properties for caching computed values
    @State private var sortedEntriesCache: [DietEntry] = []
    @State private var previousFilters: (TimeRange, MealTypeFilter, SortOrder) = (.week, .all, .newest)
    @State private var sortingChanged = false
    
    // Initialize with initial entries from parent view 
    init(initialEntries: [DietEntry] = []) {
        _dietEntries = State(initialValue: initialEntries.isEmpty ? DietEntry.mockData : initialEntries)
    }
    
    enum TimeRange: String, CaseIterable, Identifiable {
        case day = "Today"
        case week = "Week"
        case month = "Month"
        case threeMonths = "3 Months"
        
        var id: String { self.rawValue }
    }
    
    enum MealTypeFilter: String, CaseIterable, Identifiable {
        case all = "All Meals"
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
        
        var id: String { self.rawValue }
    }
    
    enum SortOrder: String, CaseIterable, Identifiable {
        case newest = "Newest First"
        case oldest = "Oldest First"
        case highestCalories = "Highest Calories"
        case lowestCalories = "Lowest Calories"
        
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
                        // Filter options
                        filterSection
                        
                        // Summary cards section
                        summarySection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                        
                        // Macro distribution section
                        macroDistributionSection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                        
                        // Meal entries list with sort controls
                        entriesSection
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            
            // Error or loading overlay
            if isLoading {
                loadingOverlay
            } else if let error = errorMessage, dietEntries.isEmpty {
                errorOverlay(message: error)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            // Animate the content appearance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showContent = true
                }
            }
            // Initialize the cache
            updateSortedEntriesCache()
        }
        .onChange(of: selectedTimeRange) { _ in updateSortedEntriesCache() }
        .onChange(of: selectedMealType) { _ in updateSortedEntriesCache() }
        .onChange(of: sortOrder) { _ in updateSortedEntriesCache() }
    }
    
    // MARK: - UI Components
    
    private var backgroundGradient: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Radial gradient with green accents for diet theme
            VStack {
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.accentGreen.opacity(0.3),
                        Color.accentBlue.opacity(0.15),
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
                Text("Nutrition History")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Add new meal button
                Button(action: {
                    // Future functionality to add meal manually
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                }
                .padding(.trailing, 8)
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44)
        }
        .frame(height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44) + 32)
    }
    
    private var filterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Time range selector
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
                                            .fill(selectedTimeRange == range ? Color.accentGreen : Color.black.opacity(0.3))
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
            
            // Meal type filter
            VStack(alignment: .leading, spacing: 12) {
                Text("Meal Type")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(MealTypeFilter.allCases) { mealType in
                            Button(action: {
                                withAnimation {
                                    selectedMealType = mealType
                                }
                            }) {
                                Text(mealType.rawValue)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(selectedMealType == mealType ? .black : .white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(selectedMealType == mealType ? mealTypeColor(mealType.rawValue) : Color.black.opacity(0.3))
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
        }
        .padding(.top, 8)
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section title
            Text("Nutrition Summary")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            // Stats cards row
            HStack(spacing: 12) {
                // Total calories
                statCard(
                    title: "Calories",
                    value: totalCalories,
                    unit: "cal",
                    icon: "flame.fill",
                    color: .accentOrange
                )
                
                // Average calories per day
                statCard(
                    title: "Daily Avg",
                    value: averageCalories,
                    unit: "cal",
                    icon: "chart.bar.fill",
                    color: .accentGreen
                )
                
                // Meal count
                statCard(
                    title: "Meals",
                    value: Double(filteredEntries.count),
                    unit: "total",
                    icon: "fork.knife",
                    color: .accentBlue,
                    showDecimals: false
                )
            }
        }
    }
    
    private var macroDistributionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section title
            Text("Macro Distribution")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            // Enhanced macro card
            ZStack {
                // Background with glass effect
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .opacity(0.2)
                
                // Macro content
                VStack(alignment: .leading, spacing: 16) {
                    // Average macros in selected period
                    HStack {
                        Text("Average Daily Macros")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("Goal Completion")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // Protein
                    macroProgressRow(
                        name: "Protein",
                        current: averageProtein,
                        target: 140,
                        color: .accentBlue
                    )
                    
                    // Carbs
                    macroProgressRow(
                        name: "Carbs",
                        current: averageCarbs,
                        target: 180,
                        color: .accentGreen
                    )
                    
                    // Fat
                    macroProgressRow(
                        name: "Fat",
                        current: averageFat,
                        target: 70,
                        color: .accentOrange
                    )
                    
                    // Simplified glass-like pie chart
                    HStack(alignment: .center, spacing: 30) {
                        // Clean, simple pie chart with glass effect
                        ZStack {
                            // Simple pie slices with normal separations
                            Circle()
                                .trim(from: 0, to: 0.32)
                                .stroke(Color.accentBlue, lineWidth: 25)
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                                .opacity(0.9)
                            
                            Circle()
                                .trim(from: 0.32, to: 0.77) // 0.32 + 0.45 = 0.77
                                .stroke(Color.accentGreen, lineWidth: 25)
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                                .opacity(0.9)
                            
                            Circle()
                                .trim(from: 0.77, to: 1.0) // 0.77 + 0.23 = 1.0
                                .stroke(Color.accentOrange, lineWidth: 25)
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                                .opacity(0.9)
                            
                            // Glass overlay for the entire chart
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 25)
                                .frame(width: 120, height: 120)
                                .blur(radius: 0.4)
                            
                            // Center hole with glass effect
                            Circle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.2)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                )
                        }
                        
                        // Simple, clean legend with proper alignment
                        VStack(alignment: .leading, spacing: 16) {
                            // Protein item
                            legendItem(color: .accentBlue, name: "Protein", percent: "32%")
                            
                            // Carbs item
                            legendItem(color: .accentGreen, name: "Carbs", percent: "45%")
                            
                            // Fat item
                            legendItem(color: .accentOrange, name: "Fat", percent: "23%")
                        }
                    }
                    .frame(height: 150)
                    .padding(.vertical, 15)
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
    
    private func legendItem(color: Color, name: String, percent: String) -> some View {
        HStack(spacing: 10) {
            // Simple colored dot
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            // Macro name
            Text(name)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            // Percentage
            Text(percent)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 45, alignment: .trailing)
        }
        .frame(height: 24)
    }
    
    private func macroProgressRow(name: String, current: Double, target: Double, color: Color) -> some View {
        let progress = min(current / target, 1.0)
        
        return VStack(spacing: 6) {
            HStack {
                Text(name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(Int(current))g / \(Int(target))g")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, alignment: .trailing)
            }
            
            // Progress bar
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 8)
                
                // Filled portion with rounded corners
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, progress * (UIScreen.main.bounds.width - 80)), height: 8)
            }
        }
    }
    
    private func statCard(title: String, value: Double, unit: String, icon: String, color: Color, showDecimals: Bool = true) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
            
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text(showDecimals ? String(format: "%.1f", value) : "\(Int(value))")
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
            // Improved title and sort section with cleaner layout
            HStack {
                Text("All Entries")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Updated sort button with better styling
                HStack(spacing: 8) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            showSortOptions.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text(sortOrder.rawValue)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                                .rotationEffect(Angle(degrees: showSortOptions ? 180 : 0))
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                                )
                        )
                    }
                    
                    Text("\(sortedEntriesCache.count) meals")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            // Sort options dropdown with improved styling
            if showSortOptions {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(SortOrder.allCases) { option in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
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
                                        .foregroundColor(.accentGreen)
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(sortOrder == option ? Color.white.opacity(0.08) : Color.clear)
                        }
                        
                        if option != SortOrder.allCases.last {
                            Divider()
                                .background(Color.white.opacity(0.1))
                                .padding(.horizontal, 4)
                        }
                    }
                }
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .opacity(0.4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                        )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                .transition(.opacity)
                .zIndex(1)
            }
            
            // Optimized list of entries with animation
            LazyVStack(spacing: 0) {
                ForEach(Array(sortedEntriesCache.enumerated()), id: \.element.id) { index, entry in
                    optimizedMealEntryRow(entry: entry)
                        .transition(.opacity)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.7)
                            .delay(Double(index) * 0.03),
                            value: sortingChanged
                        )
                    
                    if entry.id != sortedEntriesCache.last?.id {
                        Divider()
                            .background(Color.white.opacity(0.1))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .opacity(0.2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
        }
    }
    
    // Optimized and simplified meal entry row with less rendering overhead
    private func optimizedMealEntryRow(entry: DietEntry) -> some View {
        HStack(spacing: 16) {
            // Simplified meal type indicator without gradients and effects
            ZStack {
                Circle()
                    .fill(mealTypeColor(entry.mealType).opacity(0.5))
                    .frame(width: 40, height: 40)
                
                Image(systemName: mealTypeIcon(entry.mealType))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Improved meal details with better typography and spacing
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Title with meal name and date
                    Text(entry.mealType)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(entry.formattedDate)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                // Simplified macro data presentation
                HStack {
                    // Calories with simplified background
                    Text("\(entry.calories) cal")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Simplified macros display
                    HStack(spacing: 10) {
                        // Protein
                        Text("P: \(Int(entry.protein))")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.accentBlue)
                        
                        // Carbs
                        Text("C: \(Int(entry.carbs))")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.accentGreen)
                        
                        // Fat
                        Text("F: \(Int(entry.fat))")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.accentOrange)
                    }
                }
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .background(Color.clear)
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
    
    // Helper to determine icon based on meal type
    private func mealTypeIcon(_ mealType: String) -> String {
        switch mealType {
        case "Breakfast":
            return "sunrise.fill"
        case "Lunch":
            return "sun.max.fill"
        case "Dinner":
            return "moon.stars.fill"
        case "Snack":
            return "hexagon.fill"
        default:
            return "fork.knife"
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentGreen))
                    .scaleEffect(1.5)
                
                Text("Loading meal data...")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .opacity(0.5)
            )
        }
    }
    
    private func errorOverlay(message: String) -> some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                
                Text("Error Loading Data")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .opacity(0.5)
            )
        }
    }
    
    // MARK: - Cache Update Method
    
    private func updateSortedEntriesCache() {
        let currentFilters = (selectedTimeRange, selectedMealType, sortOrder)
        
        // Only recalculate if filters have changed
        if previousFilters != currentFilters || sortedEntriesCache.isEmpty {
            // Cache the filtered entries
            let filtered = filteredEntries
            
            // Sort according to current sort order
            switch sortOrder {
            case .newest:
                sortedEntriesCache = filtered.sorted { $0.dateObject > $1.dateObject }
            case .oldest:
                sortedEntriesCache = filtered.sorted { $0.dateObject < $1.dateObject }
            case .highestCalories:
                sortedEntriesCache = filtered.sorted { $0.calories > $1.calories }
            case .lowestCalories:
                sortedEntriesCache = filtered.sorted { $0.calories < $1.calories }
            }
            
            // Update previous filters
            previousFilters = currentFilters
            
            // Trigger sorting animation
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                sortingChanged.toggle()
            }
        }
    }
    
    // MARK: - Computed Properties
    
    // Filtered entries based on time range and meal type
    var filteredEntries: [DietEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        // Filter by date
        let dateFiltered = dietEntries.filter { entry in
            switch selectedTimeRange {
            case .day:
                return calendar.isDateInToday(entry.dateObject)
            case .week:
                let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
                return entry.dateObject >= weekAgo
            case .month:
                let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
                return entry.dateObject >= monthAgo
            case .threeMonths:
                let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now)!
                return entry.dateObject >= threeMonthsAgo
            }
        }
        
        // Filter by meal type
        if selectedMealType == .all {
            return dateFiltered
        } else {
            return dateFiltered.filter { $0.mealType.lowercased() == selectedMealType.rawValue.lowercased() }
        }
    }
    
    // Use cached values instead of computing on demand
    var sortedEntries: [DietEntry] {
        sortedEntriesCache
    }
    
    // Calculate total calories for selected period
    var totalCalories: Double {
        filteredEntries.reduce(0) { $0 + Double($1.calories) }
    }
    
    // Calculate average calories per day for selected period
    var averageCalories: Double {
        let daysInPeriod: Double
        switch selectedTimeRange {
        case .day: daysInPeriod = 1
        case .week: daysInPeriod = 7
        case .month: daysInPeriod = 30
        case .threeMonths: daysInPeriod = 90
        }
        
        return totalCalories / daysInPeriod
    }
    
    // Calculate average protein per day
    var averageProtein: Double {
        let totalProtein = filteredEntries.reduce(0.0) { $0 + $1.protein }
        let daysInPeriod: Double
        switch selectedTimeRange {
        case .day: daysInPeriod = 1
        case .week: daysInPeriod = 7
        case .month: daysInPeriod = 30
        case .threeMonths: daysInPeriod = 90
        }
        
        return totalProtein / daysInPeriod
    }
    
    // Calculate average carbs per day
    var averageCarbs: Double {
        let totalCarbs = filteredEntries.reduce(0.0) { $0 + $1.carbs }
        let daysInPeriod: Double
        switch selectedTimeRange {
        case .day: daysInPeriod = 1
        case .week: daysInPeriod = 7
        case .month: daysInPeriod = 30
        case .threeMonths: daysInPeriod = 90
        }
        
        return totalCarbs / daysInPeriod
    }
    
    // Calculate average fat per day
    var averageFat: Double {
        let totalFat = filteredEntries.reduce(0.0) { $0 + $1.fat }
        let daysInPeriod: Double
        switch selectedTimeRange {
        case .day: daysInPeriod = 1
        case .week: daysInPeriod = 7
        case .month: daysInPeriod = 30
        case .threeMonths: daysInPeriod = 90
        }
        
        return totalFat / daysInPeriod
    }
}

#Preview {
    DietDetailView()
        .preferredColorScheme(.dark)
} 