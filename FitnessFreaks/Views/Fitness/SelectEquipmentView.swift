import SwiftUI

// File: SelectEquipmentView.swift
// Path: /FitnessFreaks/Views/Fitness/SelectEquipmentView.swift

struct SelectEquipmentView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Section title
                Text("Select Equipment")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                
                // Placeholder text
                Text("This is a placeholder for the equipment selection screen")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 60)
                
                Spacer(minLength: 80)
            }
        }
        .scrollIndicators(.hidden)
        
        // Bottom fixed buttons
        VStack {
            Spacer()
            
            HStack(spacing: 16) {
                // Back button
                Button(action: onBack) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 50)
                        .overlay(
                            Text("Back")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                .frame(maxWidth: .infinity)
                
                // Next button
                Button(action: onNext) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.fitnessGradient1, .fitnessGradient2]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 50)
                        .overlay(
                            Text("Next")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        SelectEquipmentView(onNext: {}, onBack: {})
    }
}