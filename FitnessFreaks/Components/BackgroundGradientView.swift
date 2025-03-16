import SwiftUI

/// A reusable background gradient view that provides consistent visual styling and performance
/// across the different tabs of the application.
struct BackgroundGradientView: View {
  // The primary and secondary colors for the gradient
  let primaryColor: Color
  let secondaryColor: Color

  // Additional customization options with defaults
  var opacity: Double = 0.5
  var blurRadius: CGFloat = 40
  var startRadius: CGFloat = 20
  var endRadius: CGFloat = 600

  // Environment value for getting screen size
  @Environment(\.screenSize) private var screenSize

  // Initialize with tab type to automatically use appropriate colors
  init(forTab tab: TabType) {
    switch tab {
    case .home:
      self.primaryColor = .homepageGradient1
      self.secondaryColor = .homepageGradient2
    case .fitness:
      self.primaryColor = .fitnessGradient1
      self.secondaryColor = .fitnessGradient2
    case .chat:
      self.primaryColor = .chatGradient1
      self.secondaryColor = .chatGradient2
    case .profile:
      // Using dedicated profile gradient colors
      self.primaryColor = .profileGradient1
      self.secondaryColor = .profileGradient2
    }
  }

  // Initialize with custom colors
  init(primaryColor: Color, secondaryColor: Color, opacity: Double = 0.5, blurRadius: CGFloat = 40)
  {
    self.primaryColor = primaryColor
    self.secondaryColor = secondaryColor
    self.opacity = opacity
    self.blurRadius = blurRadius
  }

  var body: some View {
    ZStack {
      // Pure black background
      Color.black.ignoresSafeArea()

      // Vibrant gradient with frosted light source effect
      VStack {
        ZStack {
          // Main radial gradient
          RadialGradient(
            gradient: Gradient(colors: [
              primaryColor,
              secondaryColor.opacity(0.7),
              .clear,
            ]),
            center: .topTrailing,
            startRadius: startRadius,
            endRadius: endRadius
          )
          .frame(maxWidth: .infinity)
          .frame(height: screenSize.height * 0.5)
          .opacity(opacity)
          .blur(radius: blurRadius)

          // Secondary smaller highlight for "light source" effect
          RadialGradient(
            gradient: Gradient(colors: [.white.opacity(0.4), .clear]),
            center: .topTrailing,
            startRadius: 5,
            endRadius: 100
          )
          .frame(width: 200, height: 200)
          .offset(x: -20, y: 20)
          .blur(radius: 20)

          // Additional subtle mood gradient based on tab type
          if primaryColor == .homepageGradient1 {
            // For homepage: subtle bottom accent for balance
            RadialGradient(
              gradient: Gradient(colors: [.homepageGradient2.opacity(0.2), .clear]),
              center: .bottomLeading,
              startRadius: 5,
              endRadius: 300
            )
            .frame(maxWidth: .infinity)
            .frame(height: screenSize.height * 0.3)
            .offset(y: screenSize.height * 0.3)
            .opacity(0.5)
            .blur(radius: 40)
          } else if primaryColor == .fitnessGradient1 {
            // For fitness: energy pulse from center
            RadialGradient(
              gradient: Gradient(colors: [.fitnessGradient1.opacity(0.3), .clear]),
              center: .center,
              startRadius: 5,
              endRadius: 250
            )
            .frame(width: screenSize.width * 0.8)
            .frame(height: screenSize.height * 0.3)
            .offset(y: screenSize.height * 0.1)
            .opacity(0.4)
            .blur(radius: 30)
          } else if primaryColor == .chatGradient1 {
            // For chat: warm glow from bottom
            RadialGradient(
              gradient: Gradient(colors: [.chatGradient2.opacity(0.2), .clear]),
              center: .bottom,
              startRadius: 5,
              endRadius: 300
            )
            .frame(maxWidth: .infinity)
            .frame(height: screenSize.height * 0.4)
            .offset(y: screenSize.height * 0.2)
            .opacity(0.4)
            .blur(radius: 35)
          }
        }
        Spacer()
      }
      .ignoresSafeArea()

      // Subtle glass-like overlay
      Rectangle()
        .fill(.ultraThinMaterial)
        .opacity(0.1)
        .ignoresSafeArea()
    }
  }
}

// Tab types for easier selection of background colors
enum TabType {
  case home
  case fitness
  case chat
  case profile
}

// Environment key for screen size
private struct ScreenSizeKey: EnvironmentKey {
  static let defaultValue = CGSize(width: 390, height: 844)  // Default iPhone 13 size
}

extension EnvironmentValues {
  var screenSize: CGSize {
    get { self[ScreenSizeKey.self] }
    set { self[ScreenSizeKey.self] = newValue }
  }
}

// Extension to provide the screen size environment value
extension View {
  func screenSize(_ size: CGSize) -> some View {
    environment(\.screenSize, size)
  }
}

// Preview
struct BackgroundGradientView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      BackgroundGradientView(forTab: .home)
        .screenSize(CGSize(width: 390, height: 844))
        .previewDisplayName("Home Background")

      BackgroundGradientView(forTab: .fitness)
        .screenSize(CGSize(width: 390, height: 844))
        .previewDisplayName("Fitness Background")

      BackgroundGradientView(forTab: .chat)
        .screenSize(CGSize(width: 390, height: 844))
        .previewDisplayName("Chat Background")
    }
  }
}
