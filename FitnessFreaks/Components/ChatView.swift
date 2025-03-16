import SwiftUI

// Message model for chat interactions
struct ChatMessage: Identifiable {
  let id = UUID()
  let content: String
  let isUser: Bool
  let timestamp: Date
  var workouts: [WorkoutSuggestion]?
  var showStartWorkout: Bool

  // Sample message with no workouts or actions
  static func regular(content: String, isUser: Bool) -> ChatMessage {
    ChatMessage(
      content: content, isUser: isUser, timestamp: Date(), workouts: nil, showStartWorkout: false)
  }

  // Sample message with workout recommendations
  static func withWorkouts(content: String, workouts: [WorkoutSuggestion]) -> ChatMessage {
    ChatMessage(
      content: content, isUser: false, timestamp: Date(), workouts: workouts,
      showStartWorkout: false)
  }

  // Sample message with start workout option
  static func withStartWorkout(content: String, workout: WorkoutSuggestion) -> ChatMessage {
    ChatMessage(
      content: content, isUser: false, timestamp: Date(), workouts: [workout],
      showStartWorkout: true)
  }
}

// Workout suggestion model for display in chat
struct WorkoutSuggestion: Identifiable {
  let id = UUID()
  let name: String
  let type: String
  let duration: String
  let difficulty: String
  let description: String
}

struct ChatView: View {
  // State for user input and messages
  @State private var messageText = ""
  @State private var messages: [ChatMessage] = []
  @State private var scrollProxy: ScrollViewProxy?
  @State private var isAnimatingNewMessage = false

  // Init to populate sample messages
  init() {
    _messages = State(initialValue: [
      ChatMessage.regular(
        content: "Hello! I'm your FitnessFreaks AI coach. How can I help you today?", isUser: false),
      ChatMessage.regular(
        content: "I need a workout for tomorrow morning. Something quick but effective.",
        isUser: true),
      ChatMessage.withWorkouts(
        content:
          "I've got some great options for a quick and effective morning workout. Here are a few recommendations based on your profile:",
        workouts: [
          WorkoutSuggestion(
            name: "Morning Energy Boost",
            type: "HIIT",
            duration: "20 min",
            difficulty: "Medium",
            description: "Quick cardio and bodyweight exercises to energize your day"
          ),
          WorkoutSuggestion(
            name: "Quick Core Crusher",
            type: "Strength",
            duration: "15 min",
            difficulty: "Medium",
            description: "Focused abdominal workout that will fire up your core"
          ),
        ]),
      ChatMessage.regular(content: "The Morning Energy Boost looks perfect!", isUser: true),
      ChatMessage.withStartWorkout(
        content:
          "Great choice! The Morning Energy Boost is a fantastic way to start your day. Would you like to schedule this workout or start it now?",
        workout: WorkoutSuggestion(
          name: "Morning Energy Boost",
          type: "HIIT",
          duration: "20 min",
          difficulty: "Medium",
          description: "Quick cardio and bodyweight exercises to energize your day"
        )),
    ])
  }

  var body: some View {
    ZStack {
      // Using our reusable background with chat-specific colors
      BackgroundGradientView(forTab: .chat)

      VStack(spacing: 0) {
        // Header
        headerView

        // Chat messages
        ScrollViewReader { proxy in
          ScrollView {
            LazyVStack(spacing: 16) {
              ForEach(messages) { message in
                MessageView(message: message)
                  .id(message.id)
                  .scaleEffect(
                    message.id == messages.last?.id && isAnimatingNewMessage ? 0.96 : 1.0
                  )
                  .animation(
                    .spring(response: 0.3, dampingFraction: 0.7), value: isAnimatingNewMessage)
              }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
          }
          .scrollDismissesKeyboard(.immediately)
          .onTapGesture {
            hideKeyboard()
          }
          .onAppear {
            scrollProxy = proxy
            // Initial scroll to bottom
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              withAnimation {
                proxy.scrollTo(messages.last?.id, anchor: .bottom)
              }
            }
          }
          .onChange(of: messages.count) { _ in
            // Scroll to bottom when new messages appear
            withAnimation {
              proxy.scrollTo(messages.last?.id, anchor: .bottom)
            }
          }
        }

        // Input area
        messageInputView
      }
    }
    .preferredColorScheme(.dark)
  }

  // Header view
  private var headerView: some View {
    HStack {
      // Title
      VStack(alignment: .leading, spacing: 4) {
        Text("Coach Chat")
          .font(.system(size: 28, weight: .bold))
          .foregroundColor(.white)

        Text("Connect with your guide")
          .font(.subheadline)
          .foregroundColor(.white.opacity(0.7))
      }

      Spacer()

      // Options button
      Button {
        // Options action
      } label: {
        Image(systemName: "ellipsis")
          .font(.system(size: 20, weight: .medium))
          .foregroundColor(.white)
          .frame(width: 44, height: 44)
          .background(
            Circle()
              .fill(.ultraThinMaterial)
              .opacity(0.7)
          )
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 16)
    .padding(.bottom, 12)
  }

  // Input area for composing messages
  private var messageInputView: some View {
    VStack(spacing: 0) {
      Divider()
        .background(Color.white.opacity(0.1))

      HStack(spacing: 12) {
        // Text field
        ZStack {
          RoundedRectangle(cornerRadius: 24)
            .fill(Color.black.opacity(0.2))

          RoundedRectangle(cornerRadius: 24)
            .fill(.ultraThinMaterial)
            .opacity(0.6)

          RoundedRectangle(cornerRadius: 24)
            .stroke(
              LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.03)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 0.5
            )

          TextField("Message your fitness coach...", text: $messageText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .foregroundColor(.white)
        }
        .frame(height: 40)

        // Send button with theme-specific colors
        Button {
          sendMessage()
        } label: {
          ZStack {
            Circle()
              .fill(
                LinearGradient(
                  gradient: Gradient(colors: [
                    Color.chatGradient1,
                    Color.chatGradient2,
                  ]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(width: 40, height: 40)
              .shadow(
                color: Color.chatGradient1.opacity(0.5), radius: 10, x: 0, y: 0)

            Image(systemName: "arrow.up")
              .font(.system(size: 20, weight: .medium))
              .foregroundColor(.white)
          }
        }
        .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .opacity(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
    }
    .background(
      Rectangle()
        .fill(.ultraThinMaterial)
        .opacity(0.3)
        .ignoresSafeArea()
    )
  }

  // Function to send a message
  private func sendMessage() {
    let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedText.isEmpty else { return }

    // Add user message
    let userMessage = ChatMessage.regular(content: trimmedText, isUser: true)
    messages.append(userMessage)
    messageText = ""

    // Animate new message
    isAnimatingNewMessage = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      isAnimatingNewMessage = false
    }

    // Simulate AI response (in a real app, this would call your backend)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      let aiMessage = ChatMessage.regular(
        content:
          "Thanks for your message! I'm your AI fitness coach and I'm here to help you achieve your fitness goals.",
        isUser: false)
      messages.append(aiMessage)

      isAnimatingNewMessage = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        isAnimatingNewMessage = false
      }
    }
  }

  // Add this extension for keyboard dismissal
  private func hideKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

// View for individual message bubbles
struct MessageView: View {
  let message: ChatMessage
  @Environment(\.screenSize) private var screenSize

  var body: some View {
    HStack {
      if message.isUser {
        Spacer()
      }

      VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
        // Message bubble
        messageBubble

        // Timestamp
        Text(formatTime(message.timestamp))
          .font(.system(size: 11))
          .foregroundColor(.white.opacity(0.5))
          .padding(message.isUser ? .trailing : .leading, 8)
      }
      .frame(
        maxWidth: min(360, screenSize.width * 0.75),
        alignment: message.isUser ? .trailing : .leading)

      if !message.isUser {
        Spacer()
      }
    }
  }

  // Message bubble content
  private var messageBubble: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Text content
      Text(message.content)
        .font(.body)
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)

      // Optional workout recommendations
      if let workouts = message.workouts, !workouts.isEmpty {
        VStack(spacing: 12) {
          ForEach(workouts) { workout in
            WorkoutRecommendationView(workout: workout, showStartButton: message.showStartWorkout)
          }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
      }
    }
    .background(
      ZStack {
        // Bubble background
        RoundedRectangle(cornerRadius: 20)
          .fill(bubbleBackgroundGradient)
          .shadow(color: bubbleShadowColor, radius: 5, x: 0, y: 2)

        // Subtle border for glass effect
        RoundedRectangle(cornerRadius: 20)
          .stroke(
            LinearGradient(
              gradient: Gradient(colors: [
                message.isUser ? Color.white.opacity(0.2) : Color.white.opacity(0.15),
                message.isUser ? Color.white.opacity(0.1) : Color.white.opacity(0.05),
              ]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 0.5
          )
      }
    )
  }

  // Background gradient for message bubbles
  private var bubbleBackgroundGradient: LinearGradient {
    if message.isUser {
      return LinearGradient(
        gradient: Gradient(colors: [
          Color.chatGradient1.opacity(0.8),
          Color.chatGradient2.opacity(0.7),
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    } else {
      return LinearGradient(
        gradient: Gradient(colors: [
          Color.black.opacity(0.5),
          Color.black.opacity(0.3),
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    }
  }

  // Shadow color for message bubbles
  private var bubbleShadowColor: Color {
    if message.isUser {
      return Color.chatGradient1.opacity(0.3)
    } else {
      return Color.black.opacity(0.2)
    }
  }

  // Format timestamp to readable string
  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }
}

// View for workout recommendations within messages
struct WorkoutRecommendationView: View {
  let workout: WorkoutSuggestion
  let showStartButton: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      // Workout header
      HStack {
        // Type badge
        Text(workout.type)
          .font(.system(size: 12, weight: .medium))
          .padding(.horizontal, 10)
          .padding(.vertical, 4)
          .background(typeBadgeBackgroundColor(for: workout.type))
          .foregroundColor(.white)
          .cornerRadius(12)

        Spacer()

        // Duration badge
        HStack(spacing: 4) {
          Image(systemName: "clock.fill")
            .font(.system(size: 10))
          Text(workout.duration)
            .font(.system(size: 12))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.3))
        .foregroundColor(.white.opacity(0.8))
        .cornerRadius(12)

        // Difficulty badge
        HStack(spacing: 4) {
          Image(systemName: "flame.fill")
            .font(.system(size: 10))
          Text(workout.difficulty)
            .font(.system(size: 12))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.3))
        .foregroundColor(difficultyColor(for: workout.difficulty))
        .cornerRadius(12)
      }

      // Workout name
      Text(workout.name)
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(.white)

      // Workout description
      Text(workout.description)
        .font(.system(size: 14))
        .foregroundColor(.white.opacity(0.8))
        .lineLimit(2)

      // Optional start button
      if showStartButton {
        Button {
          // Start workout action
        } label: {
          HStack {
            Image(systemName: "play.fill")
              .font(.system(size: 14, weight: .bold))

            Text("Start Workout")
              .font(.system(size: 16, weight: .semibold))
          }
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 12)
          .background(
            LinearGradient(
              gradient: Gradient(colors: [
                Color.chatGradient1,
                Color.chatGradient2,
              ]),
              startPoint: .leading,
              endPoint: .trailing
            )
          )
          .cornerRadius(12)
          .shadow(color: Color.chatGradient1.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.top, 4)
      }
    }
    .padding(16)
    .background(
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color.black.opacity(0.2))

        RoundedRectangle(cornerRadius: 16)
          .fill(.ultraThinMaterial)
          .opacity(0.3)

        RoundedRectangle(cornerRadius: 16)
          .stroke(
            LinearGradient(
              gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 0.5
          )
      }
    )
  }

  // Get background color based on workout type
  private func typeBadgeBackgroundColor(for type: String) -> Color {
    switch type {
    case "Strength":
      return Color.blue
    case "Cardio":
      return Color(red: 0.95, green: 0.3, blue: 0.35)
    case "Flexibility":
      return Color(red: 0.0, green: 0.9, blue: 0.7)
    case "HIIT":
      return Color(red: 0.55, green: 0.35, blue: 0.95)
    default:
      return Color(red: 0.15, green: 0.85, blue: 0.55)
    }
  }

  // Get color based on difficulty
  private func difficultyColor(for difficulty: String) -> Color {
    switch difficulty {
    case "Easy":
      return Color(red: 0.15, green: 0.85, blue: 0.55)
    case "Medium":
      return Color(red: 1.0, green: 0.8, blue: 0.0)
    case "Hard":
      return Color(red: 0.95, green: 0.3, blue: 0.35)
    default:
      return Color.white.opacity(0.8)
    }
  }
}

// Preview
struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView()
  }
}
