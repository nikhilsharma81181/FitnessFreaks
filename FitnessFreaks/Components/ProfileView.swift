import SwiftUI

struct ProfileView: View {
  @State private var scrollOffset: CGFloat = 0

  // Sample user data
  let userName = "Nikhil Sharma"
  let userHandle = "@nikhil_fitness"
  let userBio = "Fitness enthusiast | Marathon runner | Yoga practitioner"
  let memberSince = "March 2023"

  // Stats
  let workoutsCompleted = 158
  let achievements = 23
  let followers = 412
  let following = 237

  var body: some View {
    ZStack {
      // Using our reusable background with profile-specific colors
      BackgroundGradientView(forTab: .profile)

      ScrollView {
        // Scroll position tracker
        GeometryReader { geometry in
          Color.clear.preference(
            key: ScrollOffsetPreferenceKey.self,
            value: geometry.frame(in: .named("scrollView")).minY)
        }
        .frame(height: 0)

        VStack(spacing: 24) {
          // Spacer for header
          Spacer()
            .frame(height: 90)

          // Profile header with avatar and basic info
          profileHeaderView

          // Stats row
          statsView

          // Sections
          achievementsSection

          workoutHistorySection

          settingsSection

          // Bottom spacing for tab bar
          Spacer()
            .frame(height: 90)
        }
        .padding(.horizontal, 20)
      }
      .scrollIndicators(.hidden)
      .coordinateSpace(name: "scrollView")
      .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
        scrollOffset = value
      }

      // Add translucent header
      VStack {
        // Header view
        headerView
          .padding(.horizontal, 24)
          .padding(.top, 16)
          .padding(.bottom, 8)
          .background(
            Rectangle()
              .fill(.ultraThinMaterial)
              .opacity(headerOpacity)
              .blur(radius: 0.5)
              .shadow(
                color: Color.black.opacity(headerOpacity * 0.2),
                radius: 10,
                x: 0,
                y: 5
              )
              .ignoresSafeArea()
          )

        Spacer()
      }
    }
    .preferredColorScheme(.dark)
  }

  // Header view for the sticky header
  private var headerView: some View {
    HStack {
      Text("Profile")
        .font(.system(size: headerOpacity > 0.8 ? 22 : 28, weight: .bold))
        .foregroundColor(.white)

      Spacer()

      Button {
        // Settings action
      } label: {
        Image(systemName: "gearshape.fill")
          .font(.system(size: 20))
          .foregroundColor(.white)
          .frame(width: 44, height: 44)
          .contentShape(Rectangle())
      }
    }
  }

  // Profile header with avatar and basic info
  private var profileHeaderView: some View {
    VStack(spacing: 20) {
      // Avatar
      ZStack {
        Circle()
          .fill(
            LinearGradient(
              gradient: Gradient(colors: [
                Color.vibrantMint.opacity(0.3),
                Color.vibrantTeal.opacity(0.3),
              ]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: 120, height: 120)
          .shadow(color: Color.vibrantTeal.opacity(0.3), radius: 10, x: 0, y: 0)

        Image(systemName: "person.fill")
          .font(.system(size: 60))
          .foregroundColor(.white)
      }

      // User info
      VStack(spacing: 8) {
        Text(userName)
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.white)

        Text(userHandle)
          .font(.system(size: 16))
          .foregroundColor(.white.opacity(0.7))

        Text(userBio)
          .font(.system(size: 14))
          .foregroundColor(.white.opacity(0.7))
          .multilineTextAlignment(.center)
          .padding(.top, 4)

        Text("Member since \(memberSince)")
          .font(.system(size: 12))
          .foregroundColor(.white.opacity(0.5))
          .padding(.top, 4)
      }
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 16)
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
  }

  // Stats view with key metrics
  private var statsView: some View {
    HStack(spacing: 0) {
      // Workouts
      statItem(value: "\(workoutsCompleted)", label: "Workouts")

      Divider()
        .frame(width: 1)
        .background(Color.white.opacity(0.1))
        .padding(.vertical, 8)

      // Achievements
      statItem(value: "\(achievements)", label: "Achievements")

      Divider()
        .frame(width: 1)
        .background(Color.white.opacity(0.1))
        .padding(.vertical, 8)

      // Followers
      statItem(value: "\(followers)", label: "Followers")

      Divider()
        .frame(width: 1)
        .background(Color.white.opacity(0.1))
        .padding(.vertical, 8)

      // Following
      statItem(value: "\(following)", label: "Following")
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 8)
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
              Color.white.opacity(0.05),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 0.5
        )
    )
  }

  // Helper to create individual stat items
  private func statItem(value: String, label: String) -> some View {
    VStack(spacing: 4) {
      Text(value)
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.white)

      Text(label)
        .font(.system(size: 12))
        .foregroundColor(.white.opacity(0.7))
    }
    .frame(maxWidth: .infinity)
  }

  // Achievements section
  private var achievementsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      sectionHeader(title: "Recent Achievements")

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          achievementItem(
            icon: "crown.fill",
            title: "Workout Streak",
            description: "Completed 7 consecutive days"
          )

          achievementItem(
            icon: "flame.fill",
            title: "Calorie Burner",
            description: "Burned 5000 calories in a week"
          )

          achievementItem(
            icon: "bolt.fill",
            title: "Personal Best",
            description: "New record in 5K run"
          )
        }
        .padding(.horizontal, 4)
      }
    }
  }

  // Individual achievement item
  private func achievementItem(icon: String, title: String, description: String) -> some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Image(systemName: icon)
          .font(.system(size: 24))
          .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0.3))

        Spacer()

        Text("Mar 15")
          .font(.system(size: 12))
          .foregroundColor(.white.opacity(0.5))
      }

      Spacer()

      Text(title)
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(.white)

      Text(description)
        .font(.system(size: 12))
        .foregroundColor(.white.opacity(0.7))
    }
    .padding(16)
    .frame(width: 160, height: 140)
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
              Color.white.opacity(0.05),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 0.5
        )
    )
  }

  // Workout history section
  private var workoutHistorySection: some View {
    VStack(alignment: .leading, spacing: 12) {
      sectionHeader(title: "Recent Workouts")

      ForEach(1...3, id: \.self) { index in
        workoutHistoryItem(
          date: "Mar \(15 - index)",
          name: ["Full Body Strength", "HIIT Cardio Blast", "Core & Flexibility"][index - 1],
          duration: [45, 30, 35][index - 1],
          calories: [320, 280, 180][index - 1]
        )
      }
    }
  }

  // Individual workout history item
  private func workoutHistoryItem(date: String, name: String, duration: Int, calories: Int)
    -> some View
  {
    HStack {
      // Date indicator
      VStack(spacing: 4) {
        Text(date)
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(.white)
      }
      .frame(width: 50)

      // Vertical line
      Rectangle()
        .fill(Color.white.opacity(0.2))
        .frame(width: 1, height: 50)
        .padding(.horizontal, 10)

      // Workout details
      VStack(alignment: .leading, spacing: 4) {
        Text(name)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(.white)

        HStack(spacing: 12) {
          Label("\(duration) min", systemImage: "clock.fill")
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.7))

          Label("\(calories) cal", systemImage: "flame.fill")
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.7))
        }
      }

      Spacer()
    }
    .padding(12)
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
              Color.white.opacity(0.05),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 0.5
        )
    )
  }

  // Settings section
  private var settingsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      sectionHeader(title: "Settings")

      settingsItem(icon: "person.fill", title: "Edit Profile")
      settingsItem(icon: "bell.fill", title: "Notifications")
      settingsItem(icon: "lock.fill", title: "Privacy")
      settingsItem(icon: "questionmark.circle.fill", title: "Help & Support")
    }
  }

  // Individual settings item
  private func settingsItem(icon: String, title: String) -> some View {
    HStack {
      Image(systemName: icon)
        .font(.system(size: 18))
        .foregroundColor(.white)
        .frame(width: 30)

      Text(title)
        .font(.system(size: 16))
        .foregroundColor(.white)

      Spacer()

      Image(systemName: "chevron.right")
        .font(.system(size: 14))
        .foregroundColor(.white.opacity(0.5))
    }
    .padding(16)
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
              Color.white.opacity(0.05),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 0.5
        )
    )
  }

  // Helper for section headers
  private func sectionHeader(title: String) -> some View {
    HStack {
      Text(title)
        .font(.system(size: 18, weight: .semibold))
        .foregroundColor(.white)

      Spacer()

      Button {
        // View all action
      } label: {
        Text("View All")
          .font(.system(size: 14))
          .foregroundColor(Color.vibrantMint)
      }
    }
  }

  // Computed property for header opacity based on scroll position
  private var headerOpacity: Double {
    let threshold: CGFloat = -50
    return Double(min(1.0, max(0, abs(min(0, scrollOffset)) / abs(threshold))))
  }
}

// Use the same preference key as HomeView
// (In a real app, you would put this in a shared file)
extension ScrollOffsetPreferenceKey {
  // This is just to refer to the existing preference key
}

#Preview {
  ProfileView()
}
