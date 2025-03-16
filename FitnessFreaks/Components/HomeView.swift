import SwiftUI
import UIKit

struct HomeView: View {
  @State private var scrollOffset: CGFloat = 0
  @State private var isCardPressed = false

  var body: some View {
    ScrollView {
      GeometryReader { geometry in
        Color.clear.preference(
          key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scrollView")).minY)
      }
      .frame(height: 0)

      VStack(spacing: 24) {
        // Spacer for header
        Spacer()
          .frame(height: 90)

        // Main card - WorkoutProgressCard with subtle hover animation
        WorkoutProgressCard()
          .padding(.horizontal, 24)
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
          .padding(.horizontal, 24)
          .transition(.opacity.combined(with: .move(edge: .bottom)))

        // Quick insights section with subtle fade-in animation
        QuickInsightsView()
          .padding(.horizontal, 24)
          .transition(.opacity.combined(with: .scale(scale: 0.95)))

        // Graph metrics section
        GraphMetricsView()
          .padding(.horizontal, 24)
          .padding(.top, 8)

        // Bottom spacing
        Spacer()
          .frame(height: 90)  // Space for tab bar
      }
      .padding(.vertical, 8)
    }
    .scrollIndicators(.hidden)
    .coordinateSpace(name: "scrollView")
    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
      scrollOffset = value
    }
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
