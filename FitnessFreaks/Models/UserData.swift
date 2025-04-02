import Foundation

struct UserData: Codable {
  let id: Int
  let fullName: String
  let address: String?
  let country: String?
  let profilePhoto: String?
  let email: String
  let phoneNumber: String?
  let dateOfBirth: String?
  let gender: String?
  let isActive: Bool
  let createdAt: String
  let updatedAt: String
}

extension UserData {
  static var placeholder: UserData {
    UserData(
      id: 0,
      fullName: "Loading...",
      address: nil,
      country: nil,
      profilePhoto: nil,
      email: "loading@example.com",
      phoneNumber: nil,
      dateOfBirth: nil,
      gender: nil,
      isActive: true,
      createdAt: "",
      updatedAt: ""
    )
  }

  var formattedCreatedAt: String {
    guard let date = ISO8601DateFormatter().date(from: createdAt) else {
      return "Unknown"
    }
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
}
