import SwiftUI

struct HomeView: View {
  @State private var scrollOffset: CGFloat = 0
  @State private var isCardPressed = false

  var body: some View {
    ZStack {
      // Using our reusable background with home-specific colors
      BackgroundGradientView(forTab: .home)

      ScrollView(showsIndicators: false) {
        VStack(spacing: 24) {
          // Spacer for header
          Spacer()
            .frame(height: 90)

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

          // Workout Intensity Graph
          WorkoutIntensityGraph()
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
        .background(
          GeometryReader { geometry in
            Color.clear.preference(
              key: ScrollOffsetPreferenceKey.self,
              value: geometry.frame(in: .named("scrollView")).minY
            )
          }
        )
      }
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
  }

  // Header view - can be customized for the homepage
  private var headerView: some View {
    HStack(alignment: .center, spacing: 16) {
      // Title
      VStack(alignment: .leading, spacing: 4) {
        Text("")
          .font(.system(size: headerOpacity > 0.8 ? 22 : 28, weight: .bold))
          .foregroundColor(.white)
          .animation(.spring(response: 0.3, dampingFraction: 0.7), value: headerOpacity)

        // if headerOpacity < 0.5 {
        //   Text("Track your progress")
        //     .font(.subheadline)
        //     .foregroundColor(.white.opacity(0.7))
        //     .opacity(1 - headerOpacity * 2)
        // }
      }
      .scaleEffect(x: 1.0, y: headerOpacity > 0.8 ? 0.9 : 1.0, anchor: .leading)

      Spacer()
    }
  }

  // Computed property for header opacity based on scroll position
  private var headerOpacity: Double {
    let threshold: CGFloat = -50
    return Double(min(1.0, max(0, abs(min(0, scrollOffset)) / abs(threshold))))
  }
}

// Preference key to track scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

#Preview {
  HomeView()
    .preferredColorScheme(.dark)
}
