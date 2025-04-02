import Foundation
import UIKit

enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
  case serverError(String)
  case authenticationError
}

class NetworkService {
  static let shared = NetworkService()
  private let baseURL = "https://fitness-0j1s.onrender.com"

  private init() {}

  func fetchUserData(token: String) async throws -> UserData {
    guard let url = URL(string: "\(baseURL)/api/user") else {
      throw NetworkError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    // Add debug print to verify request
    print("Request URL: \(url)")
    print("Authorization Header: Bearer \(token)")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.serverError("Invalid response type")
    }

    // Add debug print for response
    print("Response Status Code: \(httpResponse.statusCode)")
    print(
      "Response Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode response data")")

    guard (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.serverError("Server returned status code: \(httpResponse.statusCode)")
    }

    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      return try decoder.decode(UserData.self, from: data)
    } catch {
      print("Decoding Error: \(error)")
      throw NetworkError.decodingError
    }
  }

  func fetchWeightData(token: String) async throws -> [WeightEntry] {
    let url = URL(string: "\(baseURL)/api/weight-data")!

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    print("Fetching weight data from: \(url.absoluteString)")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.serverError("Invalid response")
    }

    print("Weight data response code: \(httpResponse.statusCode)")

    guard httpResponse.statusCode == 200 else {
      let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
      print("Server error: \(errorMessage)")
      throw NetworkError.serverError(
        "Server returned error \(httpResponse.statusCode): \(errorMessage)")
    }

    do {
      let decodedResponse = try JSONDecoder().decode(WeightDataResponse.self, from: data)
      print("Successfully decoded \(decodedResponse.data.count) weight entries")
      return decodedResponse.data
    } catch {
      print("Decoding error: \(error)")
      throw NetworkError.decodingError
    }
  }

  func uploadWeightFromImage(token: String, imageBase64: String) async throws -> WeightEntry {
    let url = URL(string: "\(baseURL)/api/weight-data/from-image")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    print("Uploading image to: \(url.absoluteString)")

    let requestBody: [String: Any] = [
      "imageBase64": imageBase64
    ]

    let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
    request.httpBody = jsonData

    print("Request body size: \(jsonData.count) bytes")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.serverError("Invalid response")
    }

    print("Image upload response code: \(httpResponse.statusCode)")

    guard httpResponse.statusCode == 200 else {
      let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
      print("Server error: \(errorMessage)")
      throw NetworkError.serverError(
        "Server returned error \(httpResponse.statusCode): \(errorMessage)")
    }

    do {
      // Log the raw response for debugging
      let responseString = String(data: data, encoding: .utf8) ?? "No data"
      print("Raw upload response: \(responseString)")

      // Define a detailed struct to match the exact server response format
      struct UploadResponse: Codable {
        let success: Bool
        let data: UploadedWeightData
      }
      
      struct UploadedWeightData: Codable {
        let id: Int
        let weight: Double
        let recordedAt: String
        let createdAt: String
        let updatedAt: String
        let originalReading: OriginalReading
        
        struct OriginalReading: Codable {
          let weight: Double
          let unit: String
        }
      }

      // Decode the response
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .useDefaultKeys
      let uploadResponse = try decoder.decode(UploadResponse.self, from: data)
      print("Decoded response: id=\(uploadResponse.data.id), weight=\(uploadResponse.data.weight)")
      
      // Create a WeightEntry from the response data
      let weightEntry = WeightEntry(
        id: uploadResponse.data.id,
        userId: 0, // Using a default value as it's not in the response
        weight: uploadResponse.data.weight,
        image: nil, // No image included in the response
        date: uploadResponse.data.recordedAt,
        createdAt: uploadResponse.data.createdAt,
        updatedAt: uploadResponse.data.updatedAt
      )
      
      print("Created WeightEntry: id=\(weightEntry.id), weight=\(weightEntry.weight)")
      return weightEntry
    } catch {
      print("Decoding error: \(error.localizedDescription)")
      // Print detailed error information for debugging
      if let decodingError = error as? DecodingError {
        switch decodingError {
        case .keyNotFound(let key, let context):
          print("Key '\(key)' not found: \(context.debugDescription)")
        case .typeMismatch(let type, let context):
          print("Type mismatch for type \(type): \(context.debugDescription)")
        case .valueNotFound(let type, let context):
          print("Value of type \(type) not found: \(context.debugDescription)")
        case .dataCorrupted(let context):
          print("Data corrupted: \(context.debugDescription)")
        @unknown default:
          print("Unknown decoding error: \(decodingError)")
        }
      }
      throw NetworkError.decodingError
    }
  }

  func submitWeightManually(token: String, weight: Double, date: Date) async throws -> WeightEntry {
    let url = URL(string: "\(baseURL)/api/weight-data")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    print("Submitting weight manually to: \(url.absoluteString)")
    
    // Convert date to ISO8601 format
    let isoDateFormatter = ISO8601DateFormatter()
    let dateString = isoDateFormatter.string(from: date)
    
    let requestBody: [String: Any] = [
      "weight": weight,
      "date": dateString
    ]
    
    let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
    request.httpBody = jsonData
    
    print("Request body: weight=\(weight), date=\(dateString)")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.serverError("Invalid response")
    }
    
    print("Manual weight submission response code: \(httpResponse.statusCode)")
    
    guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
      let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
      print("Server error: \(errorMessage)")
      throw NetworkError.serverError(
        "Server returned error \(httpResponse.statusCode): \(errorMessage)")
    }
    
    do {
      // Log the raw response for debugging
      let responseString = String(data: data, encoding: .utf8) ?? "No data"
      print("Raw upload response: \(responseString)")
      
      // Define a response struct to match the server format
      struct ManualEntryResponse: Codable {
        let success: Bool
        let data: EntryData
        
        struct EntryData: Codable {
          let id: Int
          let weight: Double
          let date: String
          let createdAt: String
          let updatedAt: String
          let userId: Int
        }
      }
      
      // Decode the response
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .useDefaultKeys
      let uploadResponse = try decoder.decode(ManualEntryResponse.self, from: data)
      print("Decoded response: id=\(uploadResponse.data.id), weight=\(uploadResponse.data.weight)")
      
      // Create a WeightEntry from the response data
      let weightEntry = WeightEntry(
        id: uploadResponse.data.id,
        userId: uploadResponse.data.userId,
        weight: uploadResponse.data.weight,
        image: nil,
        date: uploadResponse.data.date,
        createdAt: uploadResponse.data.createdAt,
        updatedAt: uploadResponse.data.updatedAt
      )
      
      print("Created WeightEntry: id=\(weightEntry.id), weight=\(weightEntry.weight)")
      return weightEntry
    } catch {
      print("Decoding error: \(error.localizedDescription)")
      if let decodingError = error as? DecodingError {
        switch decodingError {
        case .keyNotFound(let key, let context):
          print("Key '\(key)' not found: \(context.debugDescription)")
        case .typeMismatch(let type, let context):
          print("Type mismatch for type \(type): \(context.debugDescription)")
        case .valueNotFound(let type, let context):
          print("Value of type \(type) not found: \(context.debugDescription)")
        case .dataCorrupted(let context):
          print("Data corrupted: \(context.debugDescription)")
        @unknown default:
          print("Unknown decoding error: \(decodingError)")
        }
      }
      throw NetworkError.decodingError
    }
  }
}
