import SwiftUI
import Foundation

struct WeightEntryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var weight: String = ""
    @State private var selectedDate: Date = Date()
    @State private var notes: String = ""
    @State private var isSubmitting = false
    @State private var showSuccessIndicator = false
    @State private var errorMessage: String?
    
    // Use a closure to pass the new entry back to the parent view
    var onWeightSubmitted: ((WeightEntry) -> Void)?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black.ignoresSafeArea()
                
                // Subtle gradient background
                VStack {
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.vibrantMint.opacity(0.3),
                            Color.vibrantTeal.opacity(0.15),
                            .clear
                        ]),
                        center: .topTrailing,
                        startRadius: 20,
                        endRadius: 600
                    )
                    .frame(height: 300)
                    .opacity(0.6)
                    .blur(radius: 30)
                    
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Add Weight Entry")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 16)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Weight Input
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Weight (kg)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                HStack {
                                    TextField("0.0", text: $weight)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.ultraThinMaterial)
                                                .opacity(0.3)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                        )
                                    
                                    Text("kg")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.leading, 8)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Date Selector
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .accentColor(.vibrantMint)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.ultraThinMaterial)
                                            .opacity(0.3)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            // Notes (Optional)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes (Optional)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                TextEditor(text: $notes)
                                    .frame(minHeight: 100)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .scrollContentBackground(.hidden)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.ultraThinMaterial)
                                            .opacity(0.3)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 20)
                            
                            // Error message
                            if let error = errorMessage {
                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .transition(.opacity)
                            }
                            
                            // Submit button
                            Button(action: submitWeight) {
                                if isSubmitting {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(1.2)
                                } else if showSuccessIndicator {
                                    HStack {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Saved!")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.black)
                                } else {
                                    Text("Save Entry")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        isValidInput ? Color.vibrantMint : Color.gray.opacity(0.5)
                                    )
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .disabled(!isValidInput || isSubmitting || showSuccessIndicator)
                        }
                        .padding(.vertical, 20)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .opacity(0.2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05),
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .interactiveDismissDisabled(isSubmitting)
        .onChange(of: showSuccessIndicator) { isSuccess in
            if isSuccess {
                // Auto-dismiss after success
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    dismiss()
                }
            }
        }
    }
    
    // Validation
    private var isValidInput: Bool {
        guard let weightValue = Double(weight.trimmingCharacters(in: .whitespaces)) else {
            return false
        }
        
        return weightValue > 0 && weightValue < 500 // Reasonable weight range
    }
    
    private func submitWeight() {
        guard isValidInput else { return }
        
        // Extract weight value
        guard let weightValue = Double(weight.trimmingCharacters(in: .whitespaces)) else {
            errorMessage = "Please enter a valid weight value"
            return
        }
        
        isSubmitting = true
        errorMessage = nil
        
        Task {
            do {
                // Get auth token
                guard let token = CacheService.shared.getToken() else {
                    throw NetworkError.authenticationError
                }
                
                // Submit to API
                let newEntry = try await NetworkService.shared.submitWeightManually(
                    token: token,
                    weight: weightValue,
                    date: selectedDate
                )
                
                // Update UI on success
                await MainActor.run {
                    // Pass the new entry back to parent
                    onWeightSubmitted?(newEntry)
                    
                    // Show success and prepare to dismiss
                    isSubmitting = false
                    withAnimation {
                        showSuccessIndicator = true
                    }
                }
            } catch {
                // Handle error
                await MainActor.run {
                    isSubmitting = false
                    errorMessage = "Failed to save: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WeightEntryFormView(onWeightSubmitted: { _ in })
    }
} 