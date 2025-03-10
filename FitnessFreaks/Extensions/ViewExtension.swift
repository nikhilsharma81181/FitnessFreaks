import SwiftUI

extension View {
    // Modern card shadow with depth
    func cardShadow() -> some View {
        self.shadow(color: Color.glassShadow, radius: 15, x: 0, y: 8)
    }
    
    // Glass border effect
    func glassBorder(cornerRadius: CGFloat = 24) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.glassBorder, lineWidth: 1)
        )
    }
    
    // Enhanced glass card styling with frosted appearance
    func glassCardStyle(cornerRadius: CGFloat = 24) -> some View {
        self.background(
            ZStack {
                // Blurred background for frosted glass effect
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(0.7)
                
                // Dark overlay for contrast
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.cardBackground)
                    .opacity(0.6)
                
                // Subtle inner glow effect
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.08), Color.clear]),
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 300
                        )
                    )
                    .blendMode(.overlay)
                
                // Glass highlight
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.1), Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .blendMode(.overlay)
                
                // Refined border
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.7
                    )
            }
        )
        .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 6)
    }
    
    // Custom accent glass button style
    func glassButtonStyle(cornerRadius: CGFloat = 20, accentColor: Color? = nil) -> some View {
        self
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.cardBackground.opacity(0.6))
                    
                    if let accentColor = accentColor {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(accentColor.opacity(0.1))
                            .blendMode(.overlay)
                    }
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.glassBorder, lineWidth: 1)
                }
            )
    }
    
    // Custom indicator style for metrics
    func metricIndicatorStyle(isActive: Bool, accentColor: Color = .accentGreen) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isActive ? accentColor.opacity(0.2) : Color.cardBackground.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isActive ? accentColor : Color.clear, lineWidth: 1.5)
                    )
            )
    }
}
