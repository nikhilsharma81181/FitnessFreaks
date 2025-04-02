import SwiftUI

// File: HomeView.swift
// Path: /FitnessFreaks/Components/HomeView.swift

struct HomeView: View {
  @State private var scrollOffset: CGFloat = 0
  @State private var isCardPressed = false
  @State private var isLoaded = false

  var body: some View {
    ZStack {
      // Using our reusable background with home-specific colors
      BackgroundGradientView(forTab: .home)

      VStack(spacing: 0) {
        // Header view (moved from ContentView)
        headerView
          .padding(.horizontal, 20)
          .padding(.top, 65)
          .padding(.bottom, 16)
        // Removed the background, blur, shadow, and ignoresSafeArea

        // Main content
        ScrollView {
          VStack(spacing: 24) {
            // Main card - WorkoutProgressCard with subtle hover animation
            WorkoutProgressCard()
              .scaleEffect(isCardPressed ? 0.98 : 1.0)
              .shadow(
                color: Color.black.opacity(isCardPressed ? 0.2 : 0.3),
                radius: isCardPressed ? 10 : 15,
                x: 0,
                y: isCardPressed ? 5 : 8
              )
              .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                  isCardPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                  withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isCardPressed = false
                  }
                }
              }

            // Weight Tracking View
            WeightTrackingView()
              .transition(.opacity.combined(with: .move(edge: .bottom)))
              
            // Diet Tracking View
            DietTrackingView()
              .transition(.opacity.combined(with: .move(edge: .bottom)))

            // Quick insights section with subtle fade-in animation
            QuickInsightsView()
              .transition(.opacity.combined(with: .scale(scale: 0.95)))

            // Graph metrics section
            GraphMetricsView()
              .padding(.top, 8)

            // Bottom spacing
            Spacer()
              .frame(height: 90)  // Space for tab bar
          }
          .padding(.horizontal, 16)
          .padding(.top, 16)
          .padding(.bottom, 8)
        }
        .scrollIndicators(.hidden)
      }
    }
    .ignoresSafeArea(edges: .top)
    .onAppear {
      withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
        isLoaded = true
      }
    }
  }

  // Header with user info and profile button (from ContentView)
  private var headerView: some View {
    HStack(alignment: .center, spacing: 16) {
      // User info
      VStack(alignment: .leading, spacing: 4) {
        Text("Welcome back")
          .font(.headline)
          .foregroundColor(.white.opacity(0.7))

        Text("Nikhil Sharma")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.white)
      }

      Spacer()

      // Profile button with glass effect
      Button(action: {
        // Switch to Profile tab action
      }) {
        ZStack {
          Circle()
            .fill(.ultraThinMaterial)
            .opacity(0.7)
            .frame(width: 46, height: 46)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

          Circle()
            .stroke(
              LinearGradient(
                gradient: Gradient(colors: [
                  Color.white.opacity(0.3), Color.white.opacity(0.1),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 0.7
            )
            .frame(width: 46, height: 46)

          Image(systemName: "person.crop.circle.fill")
            .font(.system(size: 26))
            .foregroundColor(.white)
        }
      }
      .buttonStyle(HomeScalingButtonStyle())
    }
  }

  // Computed property for header opacity based on scroll position
  // Removed the headerOpacity computed property since we're no longer using it
}

// Custom preference key for scroll offset - renamed to avoid conflict
struct HomeScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

// Custom button style for scaling animation (from ContentView)
struct HomeScalingButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.94 : 1)
      .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
  }
}

#Preview {
  HomeView()
    .preferredColorScheme(.dark)
}
