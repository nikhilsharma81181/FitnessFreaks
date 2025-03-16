import SwiftUI

// File: ColorExtension.swift
// Path: /Volumes/Acasis TB4/ios_development/FitnessFreaks/FitnessFreaks/ColorExtension.swift

extension Color {
    // Background colors
    static let darkBackground = Color.black
    static let cardBackground = Color(red: 0.08, green: 0.08, blue: 0.09, opacity: 0.6)
    static let cardBackgroundAlt = Color(red: 0.12, green: 0.12, blue: 0.14, opacity: 0.5)

    // Text colors
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textTertiary = Color.white.opacity(0.5)

    // Glass effect colors
    static let glassOverlay = Color.white.opacity(0.07)
    static let glassBorder = Color.white.opacity(0.12)
    static let glassShadow = Color.black.opacity(0.2)

    // Vibrant mint/teal for gradients
    static let vibrantMint = Color(red: 0.0, green: 0.9, blue: 0.7)
    static let vibrantTeal = Color(red: 0.0, green: 0.75, blue: 0.8)

    // Homepage gradient colors - Updated for motivation and energy
    // Deep blue to blue-purple: Creates feelings of trust, reliability, and aspiration
    // Blue is associated with productivity, peace, and stability - perfect for a dashboard/overview
    static let homepageGradient1 = Color(red: 0.0, green: 0.45, blue: 0.9)  // Deeper blue - trustworthy, stable
    static let homepageGradient2 = Color(red: 0.3, green: 0.15, blue: 0.7)  // Rich purple - inspiring, aspiration

    // Fitness gradient colors - Updated for energy and vitality
    // Green to teal gradient: Evokes feelings of growth, energy, and health
    // Green is associated with vitality, renewal, and action - ideal for fitness activities
    static let fitnessGradient1 = Color(red: 0.1, green: 0.8, blue: 0.4)  // Energetic green - vitality, action
    static let fitnessGradient2 = Color(red: 0.0, green: 0.7, blue: 0.75)  // Teal - focus, endurance

    // Chat gradient colors - Updated for communication and trust
    // Purple to warmer pink: Enhances feelings of connection, wisdom, and warmth
    // Purple conveys wisdom and creativity, while warmer pink enhances communication and connection
    static let chatGradient1 = Color(red: 0.5, green: 0.35, blue: 0.9)  // Soft purple - wisdom, comfort
    static let chatGradient2 = Color(red: 0.9, green: 0.35, blue: 0.6)  // Warm pink - communication, connection

    // Profile gradient colors - New dedicated gradient for the profile page
    // Teal to green-blue: Represents personality, trust, and self-expression
    // Teal with green-blue provides a sense of balance, clarity, and reliability
    static let profileGradient1 = Color(red: 0.0, green: 0.7, blue: 0.65)  // Teal - balance, reliability
    static let profileGradient2 = Color(red: 0.15, green: 0.55, blue: 0.8)  // Blue-green - personality, clarity

    // Accent colors
    static let accentGreen = Color(red: 0.15, green: 0.85, blue: 0.55)
    static let accentBlue = Color(red: 0.0, green: 0.8, blue: 0.95)
    static let accentPurple = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let accentRed = Color(red: 0.95, green: 0.3, blue: 0.35)
    static let accentOrange = Color(red: 0.95, green: 0.6, blue: 0.3)

    // Health metric colors
    static let sleepTeal = Color(red: 0.0, green: 0.8, blue: 0.7)
    static let recoveryGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let stressRed = Color(red: 0.95, green: 0.3, blue: 0.25)
    static let stressBlue = Color(red: 0.3, green: 0.6, blue: 0.95)
}
