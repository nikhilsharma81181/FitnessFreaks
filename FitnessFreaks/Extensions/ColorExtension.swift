import SwiftUI

extension Color {
    // Background colors
    static let darkBackground = Color.black
    static let cardBackground = Color(red: 0.08, green: 0.08, blue: 0.09, opacity: 0.7) // More transparent for glass effect
    static let cardBackgroundAlt = Color(red: 0.12, green: 0.12, blue: 0.14, opacity: 0.6)
    
    // Glass effect colors
    static let glassOverlay = Color.white.opacity(0.07)
    static let glassBorder = Color.white.opacity(0.15)
    static let glassShadow = Color.black.opacity(0.25)
    
    // Vibrant mint/teal for gradients
    static let vibrantMint = Color(red: 0.0, green: 0.9, blue: 0.7)
    static let vibrantTeal = Color(red: 0.0, green: 0.75, blue: 0.8)
    
    // Text colors
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textTertiary = Color.white.opacity(0.5)
    
    // Accent colors
    static let accentGreen = Color(red: 0.15, green: 0.85, blue: 0.55)
    static let accentBlue = Color(red: 0.0, green: 0.8, blue: 0.95)
    static let accentPurple = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)
    static let accentOrange = Color(red: 0.95, green: 0.6, blue: 0.3)
    static let accentTeal = Color(red: 0.0, green: 0.75, blue: 0.7)
    
    // Gradient colors
    static let gradientPurple = Color(red: 0.45, green: 0.25, blue: 0.7, opacity: 0.6)
    static let gradientRed = Color(red: 0.65, green: 0.2, blue: 0.35, opacity: 0.6)
    static let gradientBlue = Color(red: 0.2, green: 0.4, blue: 0.7, opacity: 0.6)
    static let gradientGreen = Color(red: 0.2, green: 0.6, blue: 0.5, opacity: 0.6)
    static let gradientOrange = Color(red: 0.75, green: 0.4, blue: 0.2, opacity: 0.6)
    
    // Health metric colors
    static let sleepTeal = Color(red: 0.0, green: 0.8, blue: 0.7)
    static let recoveryGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let stressRed = Color(red: 0.95, green: 0.3, blue: 0.25)
    static let stressOrange = Color(red: 0.95, green: 0.6, blue: 0.3)
    static let stressBlue = Color(red: 0.3, green: 0.6, blue: 0.95)
    static let stressGreen = Color(red: 0.3, green: 0.85, blue: 0.5)
    static let metabolicGreen = Color(red: 0.35, green: 0.95, blue: 0.4)
}

// Extension for gradient backgrounds
extension LinearGradient {
    static let purpleRedGradient = LinearGradient(
        gradient: Gradient(colors: [.gradientPurple, .gradientRed]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let bluePurpleGradient = LinearGradient(
        gradient: Gradient(colors: [.gradientBlue, .gradientPurple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let greenBlueGradient = LinearGradient(
        gradient: Gradient(colors: [.gradientGreen, .gradientBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let orangeRedGradient = LinearGradient(
        gradient: Gradient(colors: [.gradientOrange, .gradientRed]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
