import SwiftUI

// File: BackgroundGradient.swift
// Path: /YourProjectName/Views/Components/BackgroundGradient.swift

struct BackgroundGradient: View {
    var body: some View {
        ZStack {
            // Pure black background
            Color.black
                .ignoresSafeArea()
            
            // Vibrant mint/teal gradient
            ZStack {
                // Main top-right gradient with mint/teal colors
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.vibrantMint.opacity(0.7),  // Mint
                        Color.vibrantTeal.opacity(0.5),  // Teal
                        .clear
                    ]),
                    center: .topTrailing,
                    startRadius: 5,
                    endRadius: 500
                )
                .ignoresSafeArea()
                
                // Secondary highlight for frost effect
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.3),
                        .clear
                    ]),
                    center: .topTrailing,
                    startRadius: 1,
                    endRadius: 120
                )
                .ignoresSafeArea()
                .offset(x: -20, y: 20)
                .blur(radius: 15)
                
                // Ultra-subtle frosted noise effect
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.1)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    BackgroundGradient()
}