import SwiftUI

struct PersonalInfoView: View {
  @Binding var onboardingData: UserOnboardingData
  @Environment(\.colorScheme) private var colorScheme

  // Field validation states
  @State private var showAgeError = false
  @State private var showHeightError = false
  @State private var showWeightError = false

  // Temporary storage for input validation
  @State private var ageText = ""
  @State private var heightText = ""
  @State private var weightText = ""

  // Picker state variables (for presentation)
  @State private var isShowingAgePicker = false
  @State private var isShowingHeightPicker = false
  @State private var isShowingWeightPicker = false

  // Local state for picker selections to avoid modifying binding directly until 'Done'
  @State private var temporaryAge: Int
  @State private var temporaryHeight: Double
  @State private var temporaryWeight: Double

  // Animation states
  @State private var appearAnimation = false
  @State private var shakeAnimation = false

  // Constants for picker UI
  private let pickerBackgroundColor = Color.black.opacity(0.85)

  // Initializer to set default temporary picker values
  init(onboardingData: Binding<UserOnboardingData>) {
    self._onboardingData = onboardingData
    _temporaryAge = State(initialValue: onboardingData.wrappedValue.age ?? 25)
    _temporaryHeight = State(
      initialValue: onboardingData.wrappedValue.height
        ?? (onboardingData.wrappedValue.units == .metric ? 170.0 : 67.0))
    _temporaryWeight = State(
      initialValue: onboardingData.wrappedValue.weight
        ?? (onboardingData.wrappedValue.units == .metric ? 70.0 : 154.0))
  }

  var body: some View {
    VStack(spacing: 24) {
      // Main content
      VStack(spacing: 26) {
        // Age picker button
        VStack(alignment: .leading, spacing: 10) {
          Text("Age")
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundColor(.white)

          Button {
            // Always set a reasonable default for the picker, even when the display shows a dash
            temporaryAge = onboardingData.age ?? 25
            isShowingAgePicker = true
          } label: {
            HStack {
              Text(onboardingData.age == nil ? "-" : "\(onboardingData.age!) years")
                .foregroundColor(.white)
                .font(.system(size: 16, design: .rounded))
              Spacer()
              Image(systemName: "chevron.down")
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 14))
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 18)
            .background(
              RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                  RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
            )
          }
        }
        .offset(y: appearAnimation ? 0 : 20)
        .opacity(appearAnimation ? 1 : 0.2)

        // Gender selector
        VStack(alignment: .leading, spacing: 10) {
          Text("Gender")
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
          customGenderPicker
        }
        .offset(y: appearAnimation ? 0 : 20)
        .opacity(appearAnimation ? 1 : 0.4)

        // Units toggle (Metric/Imperial)
        VStack(alignment: .leading, spacing: 10) {
          Text("Units")
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
          customUnitsPicker
        }
        .offset(y: appearAnimation ? 0 : 20)
        .opacity(appearAnimation ? 1 : 0.6)

        // Height & Weight
        VStack(spacing: 20) {
          // Height & Weight label row
          HStack {
            Text("Height")
              .font(.system(size: 17, weight: .semibold, design: .rounded))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, alignment: .leading)
            Text("Weight")
              .font(.system(size: 17, weight: .semibold, design: .rounded))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, alignment: .leading)
          }

          // Height & Weight picker buttons
          HStack(spacing: 15) {
            // Height picker button
            Button {
              // Always set a reasonable default for the picker, even when the display shows a dash
              temporaryHeight =
                onboardingData.height ?? (onboardingData.units == .metric ? 170.0 : 67.0)
              isShowingHeightPicker = true
            } label: {
              HStack {
                Text(onboardingData.height == nil ? "-" : displayHeight(onboardingData.height))
                  .foregroundColor(.white)
                  .font(.system(size: 16, design: .rounded))
                Spacer()
                Text(onboardingData.units == .metric ? "cm" : "in")
                  .foregroundColor(.white.opacity(0.6))
                  .font(.system(size: 14))
              }
              .padding(.vertical, 15)
              .padding(.horizontal, 18)
              .background(
                RoundedRectangle(cornerRadius: 16)
                  .fill(Color.white.opacity(0.08))
                  .overlay(
                    RoundedRectangle(cornerRadius: 16)
                      .stroke(Color.white.opacity(0.15), lineWidth: 1)
                  )
              )
            }
            .frame(maxWidth: .infinity)

            // Weight picker button
            Button {
              // Always set a reasonable default for the picker, even when the display shows a dash
              temporaryWeight =
                onboardingData.weight ?? (onboardingData.units == .metric ? 70.0 : 154.0)
              isShowingWeightPicker = true
            } label: {
              HStack {
                Text(onboardingData.weight == nil ? "-" : displayWeight(onboardingData.weight))
                  .foregroundColor(.white)
                  .font(.system(size: 16, design: .rounded))
                Spacer()
                Text(onboardingData.units == .metric ? "kg" : "lb")
                  .foregroundColor(.white.opacity(0.6))
                  .font(.system(size: 14))
              }
              .padding(.vertical, 15)
              .padding(.horizontal, 18)
              .background(
                RoundedRectangle(cornerRadius: 16)
                  .fill(Color.white.opacity(0.08))
                  .overlay(
                    RoundedRectangle(cornerRadius: 16)
                      .stroke(Color.white.opacity(0.15), lineWidth: 1)
                  )
              )
            }
            .frame(maxWidth: .infinity)
          }
        }
        .offset(y: appearAnimation ? 0 : 20)
        .opacity(appearAnimation ? 1 : 0.8)

        // Display BMI if available
        if let bmi = onboardingData.bmi {
          BMIView(bmi: bmi)
            .padding(.top, 6)
            .offset(y: appearAnimation ? 0 : 20)
            .opacity(appearAnimation ? 1 : 0)
        }
      }
      .padding(5)
      // Age Picker Sheet
      .sheet(isPresented: $isShowingAgePicker) {
        pickerSheetView(
          title: "Select Age", selection: $temporaryAge, range: Array(1...120), unit: "years",
          valueFormatter: { "\($0) years" }
        ) {
          onboardingData.age = temporaryAge  // Update binding on Done
        }
      }
      // Height Picker Sheet
      .sheet(isPresented: $isShowingHeightPicker) {
        pickerSheetView(
          title: "Select Height", selection: $temporaryHeight, range: heightData.range,
          unit: heightData.unit, valueFormatter: heightData.formatter
        ) {
          onboardingData.height = temporaryHeight  // Update binding on Done
        }
      }
      // Weight Picker Sheet
      .sheet(isPresented: $isShowingWeightPicker) {
        pickerSheetView(
          title: "Select Weight", selection: $temporaryWeight, range: weightData.range,
          unit: weightData.unit, valueFormatter: weightData.formatter
        ) {
          onboardingData.weight = temporaryWeight  // Update binding on Done
        }
      }
    }
    .padding(.vertical, 5)
    .onAppear {
      // Set initial values for temporary state if needed (handled by init now)
      // Trigger appearance animation
      withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
        appearAnimation = true
      }
    }
    .onChange(of: onboardingData.units) { _, newUnits in
      // Reset temporary values when units change to avoid inconsistent state
      // and ensure the picker displays the correct initial value for the new unit
      temporaryHeight = onboardingData.height ?? (newUnits == .metric ? 170.0 : 67.0)
      temporaryWeight = onboardingData.weight ?? (newUnits == .metric ? 70.0 : 154.0)
    }
  }

  // MARK: - Computed Picker Data

  private var heightData: (range: [Double], unit: String, formatter: (Double) -> String) {
    if onboardingData.units == .metric {
      let range = Array(stride(from: 120.0, through: 220.0, by: 1.0))
      let formatter: (Double) -> String = { String(format: "%.0f cm", $0) }
      return (range, "cm", formatter)
    } else {
      let range = Array(stride(from: 48.0, through: 84.0, by: 1.0))  // Inches (4'0" to 7'0")
      let formatter: (Double) -> String = { inches in
        let feet = Int(inches) / 12
        let remainingInches = Int(inches) % 12
        return "\(feet)'\(remainingInches)\""
      }
      return (range, "in", formatter)
    }
  }

  private var weightData: (range: [Double], unit: String, formatter: (Double) -> String) {
    if onboardingData.units == .metric {
      let range = Array(stride(from: 40.0, through: 150.0, by: 0.5))
      let formatter: (Double) -> String = { String(format: "%.1f kg", $0) }
      return (range, "kg", formatter)
    } else {
      let range = Array(stride(from: 88.0, through: 330.0, by: 1.0))  // Pounds
      let formatter: (Double) -> String = { String(format: "%.0f lb", $0) }
      return (range, "lb", formatter)
    }
  }

  // MARK: - Display Formatters

  private func displayHeight(_ height: Double?) -> String {
    guard let height = height else { return "-" }  // Just return dash for nil values
    if onboardingData.units == .metric {
      return String(format: "%.0f", height)
    } else {
      let feet = Int(height) / 12
      let inches = Int(height) % 12
      return "\(feet)'\(inches)\""
    }
  }

  private func displayWeight(_ weight: Double?) -> String {
    guard let weight = weight else { return "-" }  // Just return dash for nil values
    if onboardingData.units == .metric {
      return String(format: "%.1f", weight)
    } else {
      return String(format: "%.0f", weight)
    }
  }

  // MARK: - Subviews

  // Custom segmented Gender picker
  private var customGenderPicker: some View {
    HStack(spacing: 8) {
      ForEach(Gender.allCases) { gender in
        Button(action: {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            onboardingData.gender = gender
          }
        }) {
          Text(gender.rawValue)
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(onboardingData.gender == gender ? .white : .white.opacity(0.6))
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(
              onboardingData.gender == gender ? Color.white.opacity(0.2) : Color.white.opacity(0.05)
            )
            .overlay(
              RoundedRectangle(cornerRadius: 14)
                .stroke(
                  onboardingData.gender == gender
                    ? Color.white.opacity(0.4) : Color.white.opacity(0.1),
                  lineWidth: 1
                )
            )
        )
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: onboardingData.gender)
      }
    }
  }

  // Custom segmented Units picker
  private var customUnitsPicker: some View {
    HStack(spacing: 8) {
      ForEach(MeasurementUnits.allCases) { unit in
        Button {
          if onboardingData.units != unit {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
              onboardingData.units = unit
            }
            // Convert actual bound height/weight data
            convertMeasurements()
            // Reset temporary values in onChange
          }
        } label: {
          Text(unit == .metric ? "Metric" : "Imperial")
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(onboardingData.units == unit ? .white : .white.opacity(0.6))
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(
              onboardingData.units == unit ? Color.white.opacity(0.2) : Color.white.opacity(0.05)
            )
            .overlay(
              RoundedRectangle(cornerRadius: 14)
                .stroke(
                  onboardingData.units == unit
                    ? Color.white.opacity(0.4) : Color.white.opacity(0.1),
                  lineWidth: 1
                )
            )
        )
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: onboardingData.units)
      }
    }
  }

  // Convert actual bound measurements when toggling units
  private func convertMeasurements() {
    if onboardingData.units == .metric {
      // Convert Height from inches to cm
      if let heightInInches = onboardingData.height {
        onboardingData.height = heightInInches * 2.54
      }
      // Convert Weight from lb to kg
      if let weightInLb = onboardingData.weight {
        onboardingData.weight = weightInLb * 0.453592
      }
    } else {
      // Convert Height from cm to inches
      if let heightInCm = onboardingData.height {
        onboardingData.height = heightInCm / 2.54
      }
      // Convert Weight from kg to lb
      if let weightInKg = onboardingData.weight {
        onboardingData.weight = weightInKg / 0.453592
      }
    }
    // Update TextField representations if they were still used (they are not)
    // heightText = displayHeight(onboardingData.height)
    // weightText = displayWeight(onboardingData.weight)
  }

  // MARK: - Picker Sheet View

  // Generic Picker Sheet View
  private func pickerSheetView<T: Hashable & Comparable>(
    title: String, selection: Binding<T>, range: [T], unit: String,
    valueFormatter: @escaping (T) -> String, onDone: @escaping () -> Void
  ) -> some View where T: LosslessStringConvertible {
    VStack(spacing: 0) {
      // Header
      HStack {
        Button("Cancel") {
          // Use specific flags to dismiss
          if title == "Select Age" { isShowingAgePicker = false }
          if title == "Select Height" { isShowingHeightPicker = false }
          if title == "Select Weight" { isShowingWeightPicker = false }
        }
        .foregroundColor(.gray)
        .padding()

        Spacer()

        Text(title)
          .font(.headline)
          .foregroundColor(.white)

        Spacer()

        Button("Done") {
          onDone()  // Apply the temporary value to the binding
          // Use specific flags to dismiss
          if title == "Select Age" { isShowingAgePicker = false }
          if title == "Select Height" { isShowingHeightPicker = false }
          if title == "Select Weight" { isShowingWeightPicker = false }
        }
        .foregroundColor(Color.vibrantTeal)  // Use Color.vibrantTeal directly
        .fontWeight(.bold)
        .padding()
      }
      .background(pickerBackgroundColor.opacity(0.5))

      Divider().background(Color.gray.opacity(0.3))

      // Picker
      Picker(title, selection: selection) {
        ForEach(range.sorted(), id: \.self) { value in  // Ensure range is sorted for Picker
          Text(valueFormatter(value))
            .foregroundColor(.white)
            .tag(value)
        }
      }
      .pickerStyle(.wheel)
      .labelsHidden()
      .colorMultiply(.white)  // Force picker text color to white
      .background(pickerBackgroundColor)  // Apply background to Picker area
    }
    // Apply background to the whole VStack container for the sheet
    .background(pickerBackgroundColor.edgesIgnoringSafeArea(.all))
    .presentationDetents([.height(300)])
    .presentationBackground(.clear)  // Make the default sheet background clear
  }
}

// MARK: - BMI View
struct BMIView: View {
  let bmi: Double

  var body: some View {
    HStack(spacing: 15) {
      Text("BMI: \(String(format: "%.1f", bmi))")
        .foregroundColor(.white)
        .fontWeight(.medium)

      Text(bmiCategory(bmi: bmi))
        .foregroundColor(bmiColor(bmi: bmi))
        .fontWeight(.medium)
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(
          Capsule()
            .fill(bmiColor(bmi: bmi).opacity(0.15))
        )
    }
    .font(.system(size: 16, weight: .medium, design: .rounded))
    .padding(.vertical, 14)
    .padding(.horizontal, 20)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white.opacity(0.08))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    )
    .glassCard(cornerRadius: 16, transparency: 0.7)
  }

  // Get BMI category description
  private func bmiCategory(bmi: Double) -> String {
    switch bmi {
    case ..<18.5:
      return "Underweight"
    case 18.5..<25:
      return "Healthy"
    case 25..<30:
      return "Overweight"
    default:
      return "Obese"
    }
  }

  // Get color for BMI category
  private func bmiColor(bmi: Double) -> Color {
    switch bmi {
    case ..<18.5:
      return .yellow
    case 18.5..<25:
      return .green
    case 25..<30:
      return .orange
    default:
      return .red
    }
  }
}

// MARK: - Placeholder View Extension
extension View {
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content
  ) -> some View {
    ZStack(alignment: alignment) {
      placeholder().opacity(shouldShow ? 1 : 0)
      self
    }
  }
}

// MARK: - Preview
struct PersonalInfoView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      BackgroundGradientView(forTab: .profile)

      PersonalInfoView(onboardingData: .constant(UserOnboardingData()))
        .padding(.horizontal)
    }
  }
}
