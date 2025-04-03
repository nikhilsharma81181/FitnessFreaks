import SwiftUI

struct LoginView: View {
  @State private var navigateToHome = false
  @State private var logoScale: CGFloat = 0.8
  @State private var textOpacity: Double = 0
  @State private var buttonsOffset: CGFloat = 20
  @State private var buttonsOpacity: Double = 0
  @State private var isGooglePressed: Bool = false
  @State private var isApplePressed: Bool = false
  @Environment(\.colorScheme) var colorScheme
  @State private var isLoading = false
  @State private var loadingRotation: Double = 0
  @State private var loadingScale: CGFloat = 1
  @State private var showLoadingOverlay = false
  @Binding var isAuthenticated: Bool
  @State private var isAuthenticating = false

  // Updated token for the API
  private let authToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoQ3JlZGVudGlhbCI6IjU0MzIxc2hpa2hhc2hhcm1hMTIzNEBnbWFpbC5jb20iLCJpYXQiOjE3NDI3MTg5NDMsImV4cCI6MTc3NDI1NDk0M30.A7MgTx1u2fhwSQmupgZ2K6X0rvvn_fHXTQdcV0FdERc"

  // Function to generate haptic feedback
  func generateHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
  }

  // Function to simulate authentication
  func authenticateUser() {
    isAuthenticating = true
    showLoadingOverlay = true
    print("Authentication started")

    // Set up a delay to simulate network request
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      // Use real token for authentication
      let token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoQ3JlZGVudGlhbCI6IjU0MzIxc2hpa2hhc2hhcm1hMTIzNEBnbWFpbC5jb20iLCJpYXQiOjE3NDI2NzgzNTMsImV4cCI6MTc3NDIxNDM1M30.9SH0CkT1X0onVmjRmCKVEK2-_1-LKhM57s0IeLJgEjg"

      // Save the token to cache for future API calls
      CacheService.shared.saveToken(token)

      // Print token for development
      print("Saved authentication token: \(token)")
      print("Authentication completed, setting isAuthenticated = true")

      // Update UI state
      withAnimation {
        self.isAuthenticated = true
        self.isAuthenticating = false
      }

      // Hide loading overlay with slight delay for smooth transition
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        print("Authentication complete, ready for onboarding")
        self.showLoadingOverlay = false
      }
    }
  }

  var body: some View {
    NavigationView {
      ZStack {
        // Background gradient
        BackgroundGradient()

        // Light Glare Effects
        Circle()
          .fill(SwiftUI.Color.vibrantMint.opacity(0.2))
          .frame(width: 300, height: 300)
          .blur(radius: 60)
          .offset(x: 150, y: -250)

        Circle()
          .fill(SwiftUI.Color.vibrantTeal.opacity(0.15))
          .frame(width: 400, height: 400)
          .blur(radius: 80)
          .offset(x: -170, y: 300)

        VStack(spacing: 40) {
          Spacer()

          // App logo and welcome text
          VStack(spacing: 24) {
            // App logo with glow effect
            ZStack {
              // Outer glow
              Circle()
                .fill(
                  RadialGradient(
                    gradient: Gradient(colors: [
                      SwiftUI.Color.vibrantMint.opacity(0.4), SwiftUI.Color.clear,
                    ]),
                    center: .center,
                    startRadius: 20,
                    endRadius: 70
                  )
                )
                .frame(width: 120, height: 120)
                .blur(radius: 10)

              Image(systemName: "figure.run.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .foregroundColor(.white)
                .shadow(color: SwiftUI.Color.vibrantTeal.opacity(0.6), radius: 15, x: 0, y: 0)
            }
            .scaleEffect(logoScale)
            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: logoScale)

            VStack(spacing: 12) {
              Text("FITNESS FREAKS")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)

              Text("Track, analyze, and optimize your fitness journey")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
            .opacity(textOpacity)
            .animation(.easeIn(duration: 0.4).delay(0.3), value: textOpacity)
          }
          .padding(.bottom, 60)

          // Auth buttons
          VStack(spacing: 20) {
            // Google sign in button
            Button(action: {
              generateHapticFeedback()
              authenticateUser()
            }) {
              HStack(spacing: 16) {
                Image(systemName: "g.circle.fill")
                  .resizable()
                  .frame(width: 24, height: 24)
                  .foregroundColor(.white)

                Text("Continue with Google")
                  .font(.system(size: 16, weight: .semibold, design: .rounded))
                  .foregroundColor(.white)

                Spacer()

                Image(systemName: "arrow.right")
                  .foregroundColor(.white.opacity(0.8))
              }
              .padding(.horizontal, 24)
              .padding(.vertical, 18)
              .frame(maxWidth: .infinity)
            }
            .background(
              RoundedRectangle(cornerRadius: 18)
                .fill(
                  LinearGradient(
                    gradient: Gradient(colors: [
                      SwiftUI.Color.accentBlue.opacity(0.9), SwiftUI.Color.accentBlue.opacity(0.6),
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )
                )
            )
            .glassCard(cornerRadius: 18, transparency: 0.7)
            .scaleEffect(isGooglePressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isGooglePressed)
            .padding(.horizontal, 24)

            // Apple sign in button
            Button(action: {
              generateHapticFeedback()
              authenticateUser()
            }) {
              HStack(spacing: 16) {
                Image(systemName: "apple.logo")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 20, height: 24)
                  .foregroundColor(.white)

                Text("Continue with Apple")
                  .font(.system(size: 16, weight: .semibold, design: .rounded))
                  .foregroundColor(.white)

                Spacer()

                Image(systemName: "arrow.right")
                  .foregroundColor(.white.opacity(0.8))
              }
              .padding(.horizontal, 24)
              .padding(.vertical, 18)
              .frame(maxWidth: .infinity)
            }
            .background(
              RoundedRectangle(cornerRadius: 18)
                .fill(
                  LinearGradient(
                    gradient: Gradient(colors: [Color(white: 0.2), Color(white: 0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )
                )
            )
            .glassCard(cornerRadius: 18, transparency: 0.7)
            .scaleEffect(isApplePressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isApplePressed)
            .padding(.horizontal, 24)
          }
          .offset(y: buttonsOffset)
          .opacity(Double(buttonsOpacity))
          .animation(.easeOut(duration: 0.5).delay(0.5), value: buttonsOffset)
          .animation(.easeOut(duration: 0.6).delay(0.5), value: buttonsOpacity)

          // Terms and Privacy text
          Text("By continuing, you agree to our Terms of Service and Privacy Policy")
            .font(.system(size: 12, weight: .regular, design: .rounded))
            .foregroundColor(.textTertiary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .padding(.top, 20)
            .opacity(Double(buttonsOpacity))
            .animation(.easeOut(duration: 0.4).delay(0.7), value: buttonsOpacity)

          Spacer()
        }

        // Loading overlay
        if showLoadingOverlay {
          loadingOverlay
        }

        // Navigation link to home screen
        NavigationLink(
          destination: ContentView()
            .navigationBarHidden(true)
            .onAppear {
              print("ContentView appeared")
              showLoadingOverlay = false
              isGooglePressed = false
              isApplePressed = false
            },
          isActive: $navigateToHome,
          label: { EmptyView() }
        )
        .onChange(of: navigateToHome) { newValue in
          print("navigateToHome changed to: \(newValue)")
        }
      }
      .navigationBarHidden(true)
      .onAppear {
        // Animate the UI elements when the view appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          logoScale = 1.0
          textOpacity = 1.0
          buttonsOffset = 0
          buttonsOpacity = 1.0
        }
      }
    }
  }

  // Loading overlay view
  private var loadingOverlay: some View {
    ZStack {
      Color.black.opacity(0.6)
        .edgesIgnoringSafeArea(.all)

      VStack(spacing: 20) {
        // Animated circle
        Circle()
          .trim(from: 0, to: 0.7)
          .stroke(
            LinearGradient(
              gradient: Gradient(colors: [SwiftUI.Color.vibrantMint, SwiftUI.Color.vibrantTeal]),
              startPoint: .leading,
              endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: 8, lineCap: .round)
          )
          .frame(width: 60, height: 60)
          .rotationEffect(.degrees(loadingRotation))
          .scaleEffect(loadingScale)
          .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
              loadingRotation = 360
            }
            withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
              loadingScale = 1.1
            }
          }

        Text("Authenticating...")
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(.white)
      }
      .padding(40)
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(.ultraThinMaterial)
      )
    }
    .transition(AnyTransition.opacity)
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(isAuthenticated: .constant(false))
  }
}
