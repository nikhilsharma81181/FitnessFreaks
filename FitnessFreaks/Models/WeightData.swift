import Foundation

struct WeightDataResponse: Codable {
  let success: Bool
  let data: [WeightEntry]
}

struct WeightEntry: Codable, Identifiable, Equatable {
  let id: Int
  let userId: Int
  let weight: Double
  let image: String?
  let date: String
  let createdAt: String
  let updatedAt: String

  // Computed property to convert string date to Date object
  var dateObject: Date {
    ISO8601DateFormatter().date(from: date) ?? Date()
  }

  // Formatted date for display
  var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: dateObject)
  }

  // Short date format (e.g., "Mar 15")
  var shortDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter.string(from: dateObject)
  }
  
  // Equatable implementation to properly compare weight entries
  static func == (lhs: WeightEntry, rhs: WeightEntry) -> Bool {
    return lhs.id == rhs.id
  }
}
