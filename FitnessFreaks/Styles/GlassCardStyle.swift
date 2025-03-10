import SwiftUI

// File: GlassCardStyle.swift
// Path: /YourProjectName/Views/Styles/GlassCardStyle.swift

struct GlassCardStyle: ViewModifier {
    var cornerRadius: CGFloat = 24
    var transparency: Double = 0.5 // Default transparency
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Even more translucent background base
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.black.opacity(0.15 * transparency))
                    
                    // More transparent frost effect
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                        .opacity(0.5 * transparency)
                    
                    // Very subtle inner darkness for depth
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color(red: 0.1, green: 0.1, blue: 0.11, opacity: 0.3 * transparency))
                    
                    // Subtle gradient overlay - more transparent
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.white.opacity(0.05 * transparency),
                                        Color.clear
                                    ]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.overlay)
                    
                    // Very subtle edge highlight
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.white.opacity(0.12 * transparency),
                                        Color.white.opacity(0.03 * transparency)
                                    ]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                }
            )
            .shadow(color: Color.black.opacity(0.2 * transparency), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 24, transparency: Double = 0.5) -> some View {
        self.modifier(GlassCardStyle(cornerRadius: cornerRadius, transparency: transparency))
    }
}

// Preview
struct GlassCardStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Background with mint/teal gradient
            BackgroundGradient()
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Regular Glass Card")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("This uses the default transparency level")
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(24)
                .glassCard()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("More Transparent Card")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("This uses a higher transparency level")
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(24)
                .glassCard(transparency: 0.8) // More transparent
            }
            .padding(24)
        }
    }
}