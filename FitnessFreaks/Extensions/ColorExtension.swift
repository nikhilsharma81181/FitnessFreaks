import SwiftUI

extension Color {
    // Background colors
    static let darkBackground = Color.black
    static let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.11, opacity: 0.85)
    static let cardBackgroundAlt = Color(red: 0.15, green: 0.15, blue: 0.16, opacity: 0.85)
    
    // Accent colors
    static let accentBlue = Color(red: 0.0, green: 0.8, blue: 0.95)
    static let accentGreen = Color(red: 0.15, green: 0.85, blue: 0.55)
    static let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)
    static let accentPurple = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let accentOrange = Color(red: 0.95, green: 0.6, blue: 0.3)
    
    // Gradient colors
    static let gradientPurple = Color(red: 0.45, green: 0.25, blue: 0.7, opacity: 0.6)
    static let gradientRed = Color(red: 0.65, green: 0.2, blue: 0.35, opacity: 0.6)
    static let gradientBlue = Color(red: 0.2, green: 0.4, blue: 0.7, opacity: 0.6)
    static let gradientGreen = Color(red: 0.2, green: 0.6, blue: 0.5, opacity: 0.6)
    
    // Stress colors
    static let stressRed = Color(red: 0.95, green: 0.3, blue: 0.25)
    static let stressOrange = Color(red: 0.95, green: 0.6, blue: 0.3)
    static let stressBlue = Color(red: 0.3, green: 0.6, blue: 0.95)
    static let stressGreen = Color(red: 0.3, green: 0.85, blue: 0.5)
    
    // Sleep colors
    static let sleepTeal = Color(red: 0.0, green: 0.8, blue: 0.7)
    static let sleepPurple = Color(red: 0.5, green: 0.3, blue: 0.8)
    
    // Recovery colors
    static let recoveryGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    
    // Glass effect colors
    static let glassOverlay = Color.white.opacity(0.05)
    static let glassBorder = Color.white.opacity(0.15)
    static let glassShadow = Color.black.opacity(0.3)
    
    // Text colors
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textTertiary = Color.white.opacity(0.5)
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
}
