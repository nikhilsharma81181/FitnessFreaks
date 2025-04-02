import Photos
import SwiftUI
import UIKit

struct WeightTrackingView: View {
  @State private var weightEntries: [FitnessFreaks.WeightEntry] = []
  @State private var isLoading = false
  @State private var isSyncing = false
  @State private var errorMessage: String?
  @State private var showCamera = false
  @State private var capturedImage: UIImage?
  @State private var showUploadProgress = false
  @State private var uploadProgress: CGFloat = 0
  @State private var showImagePreview = false
  @State private var cameraWasDismissed = false
  @State private var showDetailView = false
  @State private var showManualEntryForm = false

  // Animation control
  @State private var showGraph = false

  // For the new weight entry from image
  @State private var processingImage = false
  @State private var uploadSuccess = false
  
  // Sync state
  @State private var needsManualSync = false

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      // Title and Add button
      HStack {
        Text("Weight Tracking")
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(.white)

        Spacer()

        // Input options menu
        Menu {
          Button(action: {
            showManualEntryForm = true
          }) {
            Label("Enter Weight", systemImage: "keyboard")
          }
          
          Button(action: {
            showCamera = true
          }) {
            Label("Take Photo", systemImage: "camera.fill")
          }
        } label: {
          HStack(spacing: 6) {
            Image(systemName: "plus")
              .font(.system(size: 16))
            Text("Add")
              .font(.system(size: 16, weight: .medium))
          }
          .foregroundColor(.vibrantMint)
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(
            Capsule()
              .stroke(Color.vibrantMint.opacity(0.7), lineWidth: 1.5)
              .background(Color.vibrantMint.opacity(0.1))
              .clipShape(Capsule())
          )
        }
      }
      .padding(.horizontal, 20)
      .padding(.top, 16)

      // Syncing indicator (now tappable)
      HStack {
        Button(action: {
          if !isSyncing {
            syncWithBackend()
          }
        }) {
          HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
              .font(.system(size: 12))
              .foregroundColor(isSyncing ? .vibrantMint : .gray.opacity(0.7))
              .rotationEffect(Angle(degrees: isSyncing ? 360 : 0))
              .animation(
                isSyncing
                  ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default,
                value: isSyncing)

            Text(isSyncing ? "Syncing..." : "Tap to sync")
              .font(.system(size: 12))
              .foregroundColor(isSyncing ? .vibrantMint : .gray.opacity(0.7))
          }
          .padding(.vertical, 4)
          .padding(.horizontal, 8)
          .background(
            Capsule()
              .fill(Color.black.opacity(0.2))
              .opacity(0)
          )
        }
        .disabled(isSyncing)
      }
      .padding(.horizontal, 20)
      .offset(y: -10)

      // Show cached data with sync indicator or error if needed
      if errorMessage != nil && weightEntries.isEmpty {
        errorView(message: errorMessage!)
      } else if weightEntries.isEmpty && !isLoading {
        emptyStateView
      } else {
        // Weight graph
        weightGraph
          .opacity(showGraph ? 1 : 0)
          .offset(y: showGraph ? 0 : 20)

        // Recent entries list with "View All" button
        recentEntriesList
          .opacity(showGraph ? 1 : 0)
          .offset(y: showGraph ? 0 : 20)
        
        // View All Data button
        Button(action: {
          showDetailView = true
        }) {
          HStack {
            Text("View All Data")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(.black)
            
            Image(systemName: "chevron.right")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.black)
          }
          .padding(.vertical, 12)
          .frame(maxWidth: .infinity)
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.vibrantMint)
          )
          .padding(.horizontal, 20)
          .padding(.top, 8)
        }
        .opacity(showGraph ? 1 : 0)
        .offset(y: showGraph ? 0 : 20)
      }
    }
    .padding(.vertical, 16)
    .background(
      RoundedRectangle(cornerRadius: 24)
        .fill(.ultraThinMaterial)
        .opacity(0.2)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 24)
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
    .overlay(
      Group {
        if processingImage {
          imageProcessingOverlay
        }
      }
    )
    .sheet(isPresented: $showCamera) {
      ImagePicker(image: $capturedImage, sourceType: .camera)
        .ignoresSafeArea()
        .onDisappear {
          if let image = capturedImage {
            cameraWasDismissed = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              showImagePreview = true
            }
          }
        }
    }
    .sheet(isPresented: $showImagePreview) {
      imagePreviewSheet
        .onDisappear {
          cameraWasDismissed = false
        }
    }
    .sheet(isPresented: $showManualEntryForm) {
      WeightEntryFormView(onWeightSubmitted: { newEntry in
        handleNewWeightEntry(newEntry)
      })
    }
    .fullScreenCover(isPresented: $showDetailView) {
      WeightDetailView(initialEntries: weightEntries)
    }
    .onChange(of: cameraWasDismissed) { wasDismissed in
      if wasDismissed && !showImagePreview && capturedImage != nil {
        showImagePreview = true
      }
    }
    .onAppear {
      loadCachedData()
      syncWithBackend()
    }
  }

  private var imagePreviewSheet: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack(spacing: 24) {
        Text("Weight Photo Preview")
          .font(.title2.bold())
          .foregroundColor(.white)

        if let image = capturedImage {
          Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .cornerRadius(16)
            .padding(.horizontal)
        }

        Text("The AI will analyze this photo to extract your weight value")
          .font(.subheadline)
          .foregroundColor(.white.opacity(0.7))
          .multilineTextAlignment(.center)
          .padding(.horizontal, 32)

        HStack(spacing: 16) {
          Button("Cancel") {
            capturedImage = nil
            showImagePreview = false
          }
          .foregroundColor(.white)
          .padding(.horizontal, 24)
          .padding(.vertical, 12)
          .background(Color.gray.opacity(0.3))
          .cornerRadius(12)

          Button("Upload") {
            showImagePreview = false
            uploadWeightImage()
          }
          .foregroundColor(.black)
          .padding(.horizontal, 24)
          .padding(.vertical, 12)
          .background(Color.vibrantMint)
          .cornerRadius(12)
        }
      }
      .padding()
    }
  }

  private var imageProcessingOverlay: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 24)
        .fill(Color.black.opacity(0.85))

      VStack(spacing: 24) {
        if uploadSuccess {
          // Success animation
          VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
              .font(.system(size: 60))
              .foregroundColor(.vibrantMint)
              .scaleEffect(uploadSuccess ? 1 : 0)
              .animation(.spring(response: 0.5, dampingFraction: 0.7), value: uploadSuccess)

            Text("Weight Updated!")
              .font(.title3.bold())
              .foregroundColor(.white)
          }
          .transition(.opacity.combined(with: .scale))
        } else {
          // Custom progress indicator
          ZStack {
            Circle()
              .stroke(Color.gray.opacity(0.3), lineWidth: 10)
              .frame(width: 100, height: 100)

            Circle()
              .trim(from: 0, to: uploadProgress)
              .stroke(
                LinearGradient(
                  gradient: Gradient(colors: [.vibrantMint, .vibrantTeal]),
                  startPoint: .leading,
                  endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 10, lineCap: .round)
              )
              .frame(width: 100, height: 100)
              .rotationEffect(Angle(degrees: -90))

            // Camera image in center
            Image(systemName: "camera.fill")
              .font(.system(size: 30))
              .foregroundColor(.white)
          }

          Text("Processing Weight Photo")
            .font(.title3.bold())
            .foregroundColor(.white)

          Text("AI is extracting your weight data\nPlease wait...")
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.7))
            .multilineTextAlignment(.center)
        }
      }
      .padding()
    }
  }

  private var loadingView: some View {
    VStack(spacing: 12) {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .vibrantMint))
        .scaleEffect(1.5)
        .padding()

      Text("Loading weight data...")
        .font(.system(size: 16))
        .foregroundColor(.white.opacity(0.7))
    }
    .frame(height: 240)
    .frame(maxWidth: .infinity)
  }

  private func errorView(message: String) -> some View {
    VStack(spacing: 12) {
      Image(systemName: "exclamationmark.triangle")
        .font(.system(size: 40))
        .foregroundColor(.yellow)
        .padding()

      Text("Error loading data")
        .font(.system(size: 18, weight: .semibold))
        .foregroundColor(.white)

      Text(message)
        .font(.system(size: 14))
        .foregroundColor(.white.opacity(0.7))
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Button("Try Again") {
        syncWithBackend()
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 8)
      .background(Color.vibrantMint.opacity(0.2))
      .cornerRadius(8)
      .padding(.top, 8)
    }
    .frame(height: 240)
    .frame(maxWidth: .infinity)
  }

  private var emptyStateView: some View {
    VStack(spacing: 16) {
      Image(systemName: "scalemass")
        .font(.system(size: 40))
        .foregroundColor(.vibrantMint)
        .padding()

      Text("No Weight Data")
        .font(.system(size: 18, weight: .semibold))
        .foregroundColor(.white)

      Text("Start tracking your weight journey by adding your first entry")
        .font(.system(size: 14))
        .foregroundColor(.white.opacity(0.7))
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Button(action: {
        showCamera = true
      }) {
        HStack {
          Image(systemName: "camera.fill")
          Text("Add First Entry")
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color.vibrantMint)
        .cornerRadius(10)
        .foregroundColor(.black)
      }
      .padding(.top, 8)
    }
    .frame(height: 240)
    .frame(maxWidth: .infinity)
  }

  private var weightGraph: some View {
    VStack(alignment: .leading, spacing: 8) {
      // Graph title with latest weight
      if let latestEntry = weightEntries.first {
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("Current Weight")
              .font(.system(size: 14))
              .foregroundColor(.white.opacity(0.7))

            HStack(alignment: .firstTextBaseline, spacing: 2) {
              Text("\(String(format: "%.1f", latestEntry.weight))")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)

              Text("kg")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            }
          }

          Spacer()

          // Show trend if we have at least 2 entries
          if weightEntries.count > 1 {
            let previousWeight = weightEntries[1].weight
            let difference = latestEntry.weight - previousWeight
            let isGain = difference >= 0

            HStack(spacing: 4) {
              Image(systemName: isGain ? "arrow.up" : "arrow.down")
                .foregroundColor(isGain ? .green : .red)

              Text("\(String(format: "%.1f", abs(difference))) kg")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isGain ? .green : .red)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.25))
            )
          }
        }
        .padding(.horizontal, 20)
      }

      // Weight line chart
      ZStack {
        // Extract data points for chart
        let dataPoints = weightEntries.reversed().map { $0.weight }

        // Chart area
        LineChart(dataPoints: dataPoints)
          .frame(height: 140)
          .padding(.horizontal, 20)
          .padding(.vertical, 16)
      }
    }
  }

  private var recentEntriesList: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Recent Entries")
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(.white)
        .padding(.horizontal, 20)

      // Recent entries (show up to 3 most recent)
      ForEach(Array(weightEntries.prefix(3))) { entry in
        HStack {
          Text(entry.shortDate)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .frame(width: 60, alignment: .leading)

          Text("\(String(format: "%.1f", entry.weight)) kg")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)

          Spacer()

          // Show camera icon if entry has image
          if entry.image != nil {
            Image(systemName: "camera.fill")
              .font(.system(size: 12))
              .foregroundColor(.vibrantMint)
              .padding(.trailing, 4)
          }

          Text(formattedTime(from: entry.date))
            .font(.system(size: 12))
            .foregroundColor(.white.opacity(0.6))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)

        if entry.id != weightEntries.prefix(3).last?.id {
          Divider()
            .background(Color.white.opacity(0.1))
            .padding(.horizontal, 20)
        }
      }
    }
  }

  private func loadCachedData() {
    if let cachedEntries = CacheService.shared.getCachedWeightData() {
      self.weightEntries = cachedEntries.sorted(by: { $0.dateObject > $1.dateObject })

      // Animate graph appearance with cached data
      withAnimation(.easeOut(duration: 0.6)) {
        self.showGraph = true
      }
    }
  }

  private func syncWithBackend() {
    guard !isSyncing else { return }

    isSyncing = true
    errorMessage = nil
    
    print("Starting sync with backend...")

    Task {
      do {
        guard let token = CacheService.shared.getToken() else {
          errorMessage = "No authentication token found"
          isSyncing = false
          return
        }
        
        // Log existing entries before sync
        print("Before sync: \(self.weightEntries.count) entries in local storage")
        if !self.weightEntries.isEmpty {
          let sample = self.weightEntries.prefix(2)
          for (index, entry) in sample.enumerated() {
            print("Local entry \(index): id=\(entry.id), weight=\(entry.weight)")
          }
        }

        let entries = try await NetworkService.shared.fetchWeightData(token: token)
        print("Received \(entries.count) entries from server")
        
        // Update on main thread
        await MainActor.run {
          // IMPORTANT: Instead of merging or selectively updating, completely replace the local data
          // with what came from the server to ensure we have the latest data
          self.weightEntries = entries.sorted(by: { $0.dateObject > $1.dateObject })
          
          print("Sync complete: Replaced local cache with \(entries.count) entries from server")
          
          // Log a few entries after sync for debugging
          if !self.weightEntries.isEmpty {
            let sample = self.weightEntries.prefix(2)
            for (index, entry) in sample.enumerated() {
              print("Entry after sync \(index): id=\(entry.id), weight=\(entry.weight)")
            }
          }
          
          self.isSyncing = false

          // Save to cache - completely overwrite the existing cache
          CacheService.shared.saveWeightData(self.weightEntries)
          print("Cache completely overwritten with server data")

          // Animate graph appearance if not already shown
          if !showGraph {
            withAnimation(.easeOut(duration: 0.6)) {
              self.showGraph = true
            }
          }
        }
      } catch {
        await MainActor.run {
          // Only show error if we don't have cached data
          if weightEntries.isEmpty {
            self.errorMessage = "Failed to load weight data: \(error.localizedDescription)"
          }
          // Reset syncing state
          self.isSyncing = false
          print("Sync failed: \(error.localizedDescription)")
        }
      }
    }
  }

  private func uploadWeightImage() {
    guard let image = capturedImage, !processingImage else { return }

    processingImage = true
    uploadProgress = 0
    uploadSuccess = false
    // Clear previous errors when starting a new upload
    errorMessage = nil

    print("Starting image upload process")

    // Simulate progress animation
    withAnimation(.easeInOut(duration: 0.8)) {
      uploadProgress = 0.3
    }

    Task {
      do {
        guard let token = CacheService.shared.getToken() else {
          print("Auth token missing")
          throw NetworkError.serverError("Authentication token not found")
        }

        // Compress the image
        guard let base64Image = ImageCompressor.compressAndConvertToBase64(image: image) else {
          print("Image compression failed")
          throw NetworkError.serverError("Failed to compress image")
        }

        print("Image compressed successfully, size: \(base64Image.count) characters")

        // Continue progress animation
        await MainActor.run {
          withAnimation(.easeInOut(duration: 0.5)) {
            uploadProgress = 0.6
          }
        }

        // Upload to server
        print("Uploading to server...")
        let newEntry = try await NetworkService.shared.uploadWeightFromImage(
          token: token,
          imageBase64: base64Image
        )
        print("Upload successful, received weight: \(newEntry.weight)kg with ID: \(newEntry.id)")

        // Complete progress animation and show success
        await MainActor.run {
          withAnimation(.easeInOut(duration: 0.5)) {
            uploadProgress = 1.0
          }

          // Show success animation
          withAnimation {
            uploadSuccess = true
          }

          // Immediately add the entry returned from the API to our list
          print("Adding new entry from API response to UI")
          // Ensure the entry doesn't already exist
          let existingEntryIndex = self.weightEntries.firstIndex(where: { $0.id == newEntry.id })
          
          if let index = existingEntryIndex {
            // Update existing entry
            print("Entry with ID \(newEntry.id) already exists, updating it")
            self.weightEntries[index] = newEntry
          } else {
            // Add new entry
            print("Adding new entry with ID \(newEntry.id) to entries list")
            self.weightEntries.append(newEntry)
          }
          
          // Re-sort the entries by date
          self.weightEntries.sort(by: { $0.dateObject > $1.dateObject })

          // Save updated list to cache
          CacheService.shared.saveWeightData(self.weightEntries)
          print("Updated cache with new entry. Total entries: \(self.weightEntries.count)")
          
          // Print the first few entries in the list for debugging
          for (index, entry) in self.weightEntries.prefix(3).enumerated() {
            print("Entry \(index): id=\(entry.id), weight=\(entry.weight), date=\(entry.formattedDate)")
          }

          // Ensure graph is visible if it wasn't
          if !showGraph {
            withAnimation(.easeOut(duration: 0.6)) {
              self.showGraph = true
            }
          }
        }

        // Show short success state, then dismiss overlay
        try? await Task.sleep(nanoseconds: 1_200_000_000) // Wait 1.2 seconds to show success checkmark

        // Update UI to dismiss overlay and reset state
        await MainActor.run {
          print("Processing complete, dismissing overlay")
          withAnimation {
            processingImage = false
            capturedImage = nil
            // Reset upload state variables
            uploadSuccess = false
            uploadProgress = 0
          }
          // Start syncing to get the latest data from the server
          syncWithBackend()
          print("Upload finished. Starting sync to get latest data.")
        }

      } catch {
        // Handle errors during the upload process
        print("Error during image upload: \(error.localizedDescription)")
        await MainActor.run {
          // Show error message specific to upload failure
          errorMessage = "Failed to process image: \(error.localizedDescription)"
          // Reset UI state on error
          withAnimation {
            processingImage = false
            uploadSuccess = false
            uploadProgress = 0
          }
          // Reset syncing state
          isSyncing = false
          // Attempt to sync regardless of upload failure to get latest data
          syncWithBackend()
          print("Upload failed. Starting sync to get latest data.")
        }
      }
    }
  }

  private func handleNewWeightEntry(_ entry: WeightEntry) {
    // Check if entry already exists
    let existingEntryIndex = self.weightEntries.firstIndex(where: { $0.id == entry.id })
    
    if let index = existingEntryIndex {
      // Update existing entry
      print("Entry with ID \(entry.id) already exists, updating it")
      self.weightEntries[index] = entry
    } else {
      // Add new entry
      print("Adding new entry with ID \(entry.id) to entries list")
      self.weightEntries.append(entry)
    }
    
    // Re-sort the entries by date
    self.weightEntries.sort(by: { $0.dateObject > $1.dateObject })
    
    // Save updated list to cache
    CacheService.shared.saveWeightData(self.weightEntries)
    print("Updated cache with new entry. Total entries: \(self.weightEntries.count)")
    
    // Ensure graph is visible if it wasn't
    if !showGraph {
      withAnimation(.easeOut(duration: 0.6)) {
        self.showGraph = true
      }
    }
    
    // Sync with backend to get the latest data
    syncWithBackend()
  }

  // Helper to format time from ISO string
  private func formattedTime(from isoString: String) -> String {
    guard let date = ISO8601DateFormatter().date(from: isoString) else {
      return ""
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
  }
}

// Image Picker component for camera access
struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  var sourceType: UIImagePickerController.SourceType

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = sourceType
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker

    init(_ parent: ImagePicker) {
      self.parent = parent
    }

    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
      if let image = info[.originalImage] as? UIImage {
        parent.image = image
      }
      picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
    }
  }
}

// Line Chart Component
struct LineChart: View {
  let dataPoints: [Double]
  
  // Animation state
  @State private var animationProgress: CGFloat = 0
  
  var body: some View {
    GeometryReader { geometry in
      if dataPoints.count > 1 {
        ZStack {
          // Draw background grid
          gridLines(in: geometry)
          
          // Draw gradient fill below curve
          getCurvePath(in: geometry)
            .fill(
              LinearGradient(
                gradient: Gradient(colors: [
                  Color.vibrantMint.opacity(0.3),
                  Color.vibrantTeal.opacity(0.01)
                ]),
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .opacity(animationProgress)
            
          // Draw curved line
          getCurvePath(in: geometry, closePath: false)
            .trim(from: 0, to: animationProgress)
            .stroke(
              LinearGradient(
                gradient: Gradient(colors: [.vibrantMint, .vibrantTeal]),
                startPoint: .leading,
                endPoint: .trailing
              ),
              style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: Color.vibrantMint.opacity(0.5), radius: 4, x: 0, y: 2)

          // Draw points
          ForEach(0..<dataPoints.count, id: \.self) { index in
            ZStack {
              // Outer glow
              Circle()
                .fill(Color.vibrantMint.opacity(0.3))
                .frame(width: 12, height: 12)
                
              // Inner circle
              Circle()
                .fill(Color.white)
                .frame(width: 6, height: 6)
            }
            .position(
              x: xPosition(for: index, in: geometry),
              y: yPosition(for: dataPoints[index], in: geometry)
            )
            .opacity(animationProgress >= CGFloat(index) / CGFloat(dataPoints.count - 1) ? 1 : 0)
          }
        }
        .onAppear {
          withAnimation(.easeOut(duration: 1.2)) {
            animationProgress = 1.0
          }
        }
      } else {
        // Show message if not enough data
        Text("Not enough data for chart")
          .font(.system(size: 14))
          .foregroundColor(.white.opacity(0.7))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }

  private func getCurvePath(in geometry: GeometryProxy, closePath: Bool = true) -> Path {
    Path { path in
      guard dataPoints.count > 1 else { return }
      
      let points = (0..<dataPoints.count).map { index -> CGPoint in
        CGPoint(
          x: xPosition(for: index, in: geometry),
          y: yPosition(for: dataPoints[index], in: geometry)
        )
      }
      
      // Start at the first point
      path.move(to: points[0])
      
      // Draw curved lines between points
      if points.count > 1 {
        for i in 1..<points.count {
          let previous = points[i-1]
          let current = points[i]
          
          // Calculate control points for the curve
          let controlPoint1 = CGPoint(
            x: previous.x + (current.x - previous.x) / 2,
            y: previous.y
          )
          
          let controlPoint2 = CGPoint(
            x: previous.x + (current.x - previous.x) / 2,
            y: current.y
          )
          
          // Add the curve
          path.addCurve(to: current, control1: controlPoint1, control2: controlPoint2)
        }
      }
      
      // If we're creating the fill path, close the path at the bottom
      if closePath {
        // Go to the bottom right
        path.addLine(to: CGPoint(
          x: xPosition(for: dataPoints.count - 1, in: geometry),
          y: geometry.size.height
        ))
        
        // Go to the bottom left
        path.addLine(to: CGPoint(
          x: xPosition(for: 0, in: geometry),
          y: geometry.size.height
        ))
        
        // Close the path
        path.closeSubpath()
      }
    }
  }

  private func gridLines(in geometry: GeometryProxy) -> some View {
    let horizontalLines = 5

    return VStack(spacing: 0) {
      ForEach(0..<horizontalLines, id: \.self) { index in
        Spacer()
        Rectangle()
          .fill(Color.white.opacity(0.1))
          .frame(height: 1)
      }
      Spacer()
    }
  }

  private func xPosition(for index: Int, in geometry: GeometryProxy) -> CGFloat {
    guard dataPoints.count > 1 else { return 0 }
    let width = geometry.size.width
    let segmentWidth = width / CGFloat(dataPoints.count - 1)
    return CGFloat(index) * segmentWidth
  }

  private func yPosition(for value: Double, in geometry: GeometryProxy) -> CGFloat {
    guard let min = dataPoints.min(), let max = dataPoints.max() else { return 0 }
    if min == max { return geometry.size.height / 2 }  // Avoid division by zero

    let padding: CGFloat = 20
    let availableHeight = geometry.size.height - (padding * 2)
    let normalizedValue = CGFloat((value - min) / (max - min))
    return geometry.size.height - (normalizedValue * availableHeight + padding)
  }
}

#Preview {
  ZStack {
    Color.black.edgesIgnoringSafeArea(.all)
    WeightTrackingView()
      .padding()
  }
}
