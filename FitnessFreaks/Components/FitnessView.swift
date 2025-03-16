import SwiftUI

struct WorkoutPlan: Identifiable, Equatable {
  var id = UUID()
  let name: String
  let type: String
  let duration: String
  let frequency: String
  let lastUsed: String
}

struct FitnessView: View {
  // Sample data for workout plans
  let workoutPlans = [
    WorkoutPlan(
      name: "Full Body Strength", type: "Strength", duration: "45 min", frequency: "3x week",
      lastUsed: "2 days ago"),
    WorkoutPlan(
      name: "HIIT Cardio Blast", type: "Cardio", duration: "30 min", frequency: "2x week",
      lastUsed: "Yesterday"),
    WorkoutPlan(
      name: "Upper Body Focus", type: "Strength", duration: "50 min", frequency: "2x week",
      lastUsed: "1 week ago"),
    WorkoutPlan(
      name: "Core & Flexibility", type: "Flexibility", duration: "35 min", frequency: "2x week",
      lastUsed: "3 days ago"),
    WorkoutPlan(
      name: "Leg Day Challenge", type: "Strength", duration: "55 min", frequency: "1x week",
      lastUsed: "5 days ago"),
  ]

  // Sample categories for quick filters
  let categories = ["All", "Strength", "Cardio", "Flexibility", "HIIT", "Recovery"]
  @State private var selectedCategory = "All"

  // State for animations
  @State private var isLoaded = false
  @State private var showingNewWorkoutSheet = false
  @State private var showingDiscoverSheet = false

  var body: some View {
    ZStack {
      // Using our reusable background with fitness-specific colors
      BackgroundGradientView(forTab: .fitness)

      VStack(spacing: 0) {
        // Header with title and notification
        headerView

        ScrollView {
          VStack(spacing: 24) {
            // Action buttons
            actionButtonsView

            // Categories carousel
            categoriesView

            // Your workouts section
            workoutListView

            // Weekly Stats Section
            weeklyStatsView

            // Space for tab bar
            Spacer()
              .frame(height: 90)
          }
          .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
      }
    }
    .preferredColorScheme(.dark)
    .onAppear {
      withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
        isLoaded = true
      }
    }
  }

  // Header view with title and notification
  private var headerView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("Your Fitness")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.white)

        Text("Energize your day")
          .font(.subheadline)
          .foregroundColor(.white.opacity(0.7))
      }

      Spacer()

      // Notification button
      notificationButton
    }
    .padding(.horizontal, 20)
    .padding(.top, 16)
    .padding(.bottom, 16)
  }

  // Notification button extracted to reduce complexity
  private var notificationButton: some View {
    Button {
      // Action for notification
    } label: {
      ZStack {
        Circle()
          .fill(.ultraThinMaterial)
          .opacity(0.7)
          .frame(width: 46, height: 46)
          .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

        Image(systemName: "bell.fill")
          .font(.system(size: 20))
          .foregroundColor(.white)

        // Notification indicator
        Circle()
          .fill(Color(red: 0.95, green: 0.3, blue: 0.35))  // accentRed
          .frame(width: 10, height: 10)
          .offset(x: 8, y: -8)
      }
    }
  }

  // Action buttons for new workout and discover
  private var actionButtonsView: some View {
    HStack(spacing: 16) {
      // New Workout Button
      newWorkoutButton

      // Discover Workouts Button
      discoverButton
    }
  }

  // New workout button extracted to reduce complexity
  private var newWorkoutButton: some View {
    Button {
      showingNewWorkoutSheet = true
    } label: {
      HStack(spacing: 12) {
        Image(systemName: "plus.circle.fill")
          .font(.system(size: 20))
          .foregroundColor(Color(red: 0.0, green: 0.9, blue: 0.7))  // vibrantMint

        Text("New Workout")
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(.white)

        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(
        actionButtonBackground(color: Color(red: 0.0, green: 0.9, blue: 0.7))  // vibrantMint
      )
    }
    .opacity(isLoaded ? 1 : 0)
    .offset(y: isLoaded ? 0 : 20)
    .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1), value: isLoaded)
  }

  // Discover button extracted to reduce complexity
  private var discoverButton: some View {
    Button {
      showingDiscoverSheet = true
    } label: {
      HStack(spacing: 12) {
        Image(systemName: "magnifyingglass")
          .font(.system(size: 20))
          .foregroundColor(Color(red: 0.55, green: 0.35, blue: 0.95))  // accentPurple

        Text("Discover Workouts")
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(.white)

        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(
        actionButtonBackground(color: Color(red: 0.55, green: 0.35, blue: 0.95))  // accentPurple
      )
    }
    .opacity(isLoaded ? 1 : 0)
    .offset(y: isLoaded ? 0 : 20)
    .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.2), value: isLoaded)
  }

  // Helper function to create action button backgrounds
  private func actionButtonBackground(color: Color) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.black.opacity(0.3))

      RoundedRectangle(cornerRadius: 16)
        .fill(.ultraThinMaterial)
        .opacity(0.6)

      RoundedRectangle(cornerRadius: 16)
        .fill(
          LinearGradient(
            gradient: Gradient(
              colors: [
                color.opacity(0.15),
                color.opacity(0.05),
              ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .blendMode(.overlay)

      RoundedRectangle(cornerRadius: 16)
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.03)]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 0.5
        )
    }
  }

  // Categories carousel
  private var categoriesView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(categories, id: \.self) { category in
          categoryButton(for: category)
        }
      }
      .padding(.horizontal, 4)
    }
    .opacity(isLoaded ? 1 : 0)
    .offset(y: isLoaded ? 0 : 15)
    .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.3), value: isLoaded)
  }

  // Helper function to create category buttons
  private func categoryButton(for category: String) -> some View {
    Button {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
        selectedCategory = category
      }
    } label: {
      Text(category)
        .font(.system(size: 14, weight: selectedCategory == category ? .semibold : .medium))
        .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.7))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(categoryButtonBackground(for: category))
    }
  }

  // Helper function to create category button backgrounds
  private func categoryButtonBackground(for category: String) -> some View {
    Capsule()
      .fill(
        selectedCategory == category
          ? LinearGradient(
            gradient: Gradient(colors: [
              Color(red: 0.0, green: 0.9, blue: 0.7),  // vibrantMint
              Color(red: 0.0, green: 0.75, blue: 0.8),  // vibrantTeal
            ]),
            startPoint: .leading,
            endPoint: .trailing
          )
          : LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.3)]),
            startPoint: .leading,
            endPoint: .trailing
          )
      )
      .overlay(
        Capsule()
          .stroke(
            selectedCategory == category
              ? Color(red: 0.0, green: 0.9, blue: 0.7).opacity(0.7)  // vibrantMint
              : Color.white.opacity(0.1),
            lineWidth: 0.5
          )
      )
  }

  // Workout list view
  private var workoutListView: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Section header
      workoutListHeader

      // Workout plan cards
      LazyVStack(spacing: 16) {
        ForEach(Array(filteredWorkouts.enumerated()), id: \.element.id) { index, workout in
          workoutCard(workout, index: index)
        }
      }
    }
    .opacity(isLoaded ? 1 : 0)
    .offset(y: isLoaded ? 0 : 20)
    .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.4), value: isLoaded)
  }

  // Workout list header extracted to reduce complexity
  private var workoutListHeader: some View {
    HStack {
      Text("Your Workouts")
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(.white)

      Spacer()

      Button {
        // View all action
      } label: {
        Text("View All")
          .font(.system(size: 14, weight: .medium))
          .foregroundColor(Color(red: 0.0, green: 0.9, blue: 0.7))  // vibrantMint
      }
    }
    .padding(.top, 8)
  }

  // Weekly stats view
  private var weeklyStatsView: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Weekly Overview")
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(.white)

      HStack(spacing: 16) {
        // Workouts Completed
        statCard(
          value: "5",
          label: "Workouts",
          icon: "figure.run",
          color: Color(red: 0.15, green: 0.85, blue: 0.55)  // accentGreen
        )

        // Total Time
        statCard(
          value: "3.5",
          label: "Hours",
          icon: "clock.fill",
          color: Color(red: 0.0, green: 0.9, blue: 0.7)  // vibrantMint
        )

        // Streak
        statCard(
          value: "12",
          label: "Day Streak",
          icon: "flame.fill",
          color: Color(red: 1.0, green: 0.6, blue: 0.0)  // accentOrange (manually defined since no extension)
        )
      }
    }
    .padding(.top, 8)
    .opacity(isLoaded ? 1 : 0)
    .offset(y: isLoaded ? 0 : 20)
    .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.5), value: isLoaded)
  }

  // Individual workout card - broken down to fix the compiler error
  private func workoutCard(_ workout: WorkoutPlan, index: Int) -> some View {
    HStack(spacing: 16) {
      // Workout type icon with colored background
      workoutIconView(for: workout)

      // Workout details
      workoutDetailsView(for: workout)

      Spacer()

      // Last used tag
      workoutLastUsedView(for: workout)
    }
    .padding(16)
    .background(workoutCardBackground())
    .contextMenu {
      workoutContextMenu()
    }
    .opacity(isLoaded ? 1 : 0)
    .offset(y: isLoaded ? 0 : 20)
    .animation(
      .spring(response: 0.4, dampingFraction: 0.7).delay(0.4 + (Double(index) * 0.05)),
      value: isLoaded)
  }

  // Workout icon view extracted to reduce complexity
  private func workoutIconView(for workout: WorkoutPlan) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 14)
        .fill(
          LinearGradient(
            gradient: Gradient(
              colors: colorForType(workout.type)
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .frame(width: 56, height: 56)

      Image(systemName: iconForType(workout.type))
        .font(.system(size: 24))
        .foregroundColor(.white)
    }
  }

  // Workout details view extracted to reduce complexity
  private func workoutDetailsView(for workout: WorkoutPlan) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(workout.name)
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(.white)

      HStack(spacing: 12) {
        Label(workout.duration, systemImage: "clock.fill")
          .font(.system(size: 12))
          .foregroundColor(.white.opacity(0.7))

        Label(workout.frequency, systemImage: "calendar")
          .font(.system(size: 12))
          .foregroundColor(.white.opacity(0.7))
      }
    }
  }

  // Workout last used view extracted to reduce complexity
  private func workoutLastUsedView(for workout: WorkoutPlan) -> some View {
    VStack(alignment: .trailing, spacing: 4) {
      Text("Last Used")
        .font(.system(size: 10))
        .foregroundColor(.white.opacity(0.5))

      Text(workout.lastUsed)
        .font(.system(size: 12, weight: .medium))
        .foregroundColor(.white.opacity(0.7))
    }
  }

  // Workout card background extracted to reduce complexity
  private func workoutCardBackground() -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.black.opacity(0.2))

      RoundedRectangle(cornerRadius: 16)
        .fill(.ultraThinMaterial)
        .opacity(0.6)

      RoundedRectangle(cornerRadius: 16)
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.03)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 0.5
        )
    }
  }

  // Workout context menu extracted to reduce complexity
  private func workoutContextMenu() -> some View {
    Group {
      Button(action: {
        // Start workout action
      }) {
        Label("Start Workout", systemImage: "play.fill")
      }

      Button(action: {
        // Edit workout action
      }) {
        Label("Edit Workout", systemImage: "pencil")
      }

      Button(action: {
        // Duplicate workout action
      }) {
        Label("Duplicate", systemImage: "plus.square.on.square")
      }

      Button(action: {
        // Delete workout action
      }) {
        Label("Delete", systemImage: "trash")
          .foregroundColor(.red)
      }
    }
  }

  // Stat card component - broken down to fix the compiler error
  private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
    VStack(spacing: 12) {
      // Icon
      statCardIcon(icon: icon, color: color)

      // Value and label
      statCardValueLabel(value: value, label: label)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
    .background(statCardBackground(color: color))
  }

  // Stat card icon extracted to reduce complexity
  private func statCardIcon(icon: String, color: Color) -> some View {
    ZStack {
      Circle()
        .fill(color.opacity(0.2))
        .frame(width: 50, height: 50)

      Image(systemName: icon)
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(color)
    }
  }

  // Stat card value and label extracted to reduce complexity
  private func statCardValueLabel(value: String, label: String) -> some View {
    VStack(spacing: 4) {
      Text(value)
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.white)

      Text(label)
        .font(.system(size: 12))
        .foregroundColor(.white.opacity(0.7))
    }
  }

  // Stat card background extracted to reduce complexity
  private func statCardBackground(color: Color) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.black.opacity(0.2))

      RoundedRectangle(cornerRadius: 16)
        .fill(.ultraThinMaterial)
        .opacity(0.6)

      RoundedRectangle(cornerRadius: 16)
        .fill(
          LinearGradient(
            gradient: Gradient(
              colors: [
                color.opacity(0.15),
                color.opacity(0.05),
              ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .blendMode(.overlay)

      RoundedRectangle(cornerRadius: 16)
        .stroke(
          LinearGradient(
            gradient: Gradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.03)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 0.5
        )
    }
  }

  // Helper function to filter workouts by category
  private var filteredWorkouts: [WorkoutPlan] {
    if selectedCategory == "All" {
      return workoutPlans
    } else {
      return workoutPlans.filter { $0.type == selectedCategory }
    }
  }

  // Helper function to get icon for workout type
  private func iconForType(_ type: String) -> String {
    switch type {
    case "Strength":
      return "dumbbell.fill"
    case "Cardio":
      return "heart.circle.fill"
    case "Flexibility":
      return "figure.yoga"
    case "HIIT":
      return "bolt.fill"
    default:
      return "figure.run"
    }
  }

  // Helper function to get color for workout type
  private func colorForType(_ type: String) -> [Color] {
    switch type {
    case "Strength":
      return [Color.blue, Color.blue.opacity(0.7)]  // accentBlue
    case "Cardio":
      return [Color(red: 0.95, green: 0.3, blue: 0.35), Color(red: 1.0, green: 0.6, blue: 0.0)]  // accentRed, accentOrange
    case "Flexibility":
      return [Color(red: 0.0, green: 0.9, blue: 0.7), Color(red: 0.0, green: 0.75, blue: 0.8)]  // vibrantMint, vibrantTeal
    case "HIIT":
      return [Color(red: 0.55, green: 0.35, blue: 0.95), Color.blue]  // accentPurple, accentBlue
    default:
      return [Color(red: 0.15, green: 0.85, blue: 0.55), Color(red: 0.0, green: 0.9, blue: 0.7)]  // accentGreen, vibrantMint
    }
  }
}

// Preview
struct FitnessView_Previews: PreviewProvider {
  static var previews: some View {
    FitnessView()
  }
}
