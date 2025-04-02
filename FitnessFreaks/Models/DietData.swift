import Foundation

struct DietEntry: Codable, Identifiable, Equatable {
    let id: Int
    let mealType: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let date: String
    let image: String?
    
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
    
    // Equatable implementation to properly compare diet entries
    static func == (lhs: DietEntry, rhs: DietEntry) -> Bool {
        return lhs.id == rhs.id
    }
}

// Mock data for UI development
extension DietEntry {
    static var mockData: [DietEntry] = [
        DietEntry(id: 1, mealType: "Breakfast", calories: 450, protein: 25, carbs: 35, fat: 15, date: "2025-03-27T08:30:00.000Z", image: nil),
        DietEntry(id: 2, mealType: "Lunch", calories: 650, protein: 40, carbs: 50, fat: 20, date: "2025-03-27T13:15:00.000Z", image: nil),
        DietEntry(id: 3, mealType: "Dinner", calories: 550, protein: 35, carbs: 40, fat: 18, date: "2025-03-26T19:30:00.000Z", image: nil),
        DietEntry(id: 4, mealType: "Snack", calories: 200, protein: 10, carbs: 15, fat: 8, date: "2025-03-26T16:00:00.000Z", image: nil),
        DietEntry(id: 5, mealType: "Breakfast", calories: 400, protein: 22, carbs: 30, fat: 14, date: "2025-03-25T08:45:00.000Z", image: nil)
    ]
} 