import SwiftUI

extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.glassShadow, radius: 15, x: 0, y: 8)
    }
    
    func glassBorder() -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.glassBorder, lineWidth: 1)
        )
    }
} 