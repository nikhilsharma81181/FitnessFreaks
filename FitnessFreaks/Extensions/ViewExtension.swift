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
    
    // Glass card background styling
    func glassCardStyle(cornerRadius: CGFloat = 28) -> some View {
        self.background(
            ZStack {
                // Base background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.cardBackground)
                
                // Subtle gradient overlay
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.1), Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.overlay)
                
                // Glass effect border
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.glassBorder, lineWidth: 1)
            }
        )
        .shadow(color: Color.glassShadow, radius: 15, x: 0, y: 10)
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
