import Foundation

class CacheService {
  static let shared = CacheService()
  private let tokenKey = "auth_token"
  private let userDefaults = UserDefaults.standard
  private let weightDataKey = "cached_weight_data"

  private init() {}

  func saveToken(_ token: String) {
    userDefaults.setValue(token, forKey: tokenKey)
    print("Auth token saved to cache")
  }

  func getToken() -> String? {
    let token = userDefaults.string(forKey: tokenKey)
    if token == nil {
      print("No auth token found in cache")
    } else {
      print("Auth token retrieved from cache")
    }
    return token
  }

  func clearToken() {
    userDefaults.removeObject(forKey: tokenKey)
  }

  func saveWeightData(_ entries: [FitnessFreaks.WeightEntry]) {
    do {
      let encoder = JSONEncoder()
      let encodedData = try encoder.encode(entries)
      userDefaults.setValue(encodedData, forKey: weightDataKey)
      print("Saved \(entries.count) weight entries to cache")
    } catch {
      print("Error saving weight data to cache: \(error)")
    }
  }

  func getCachedWeightData() -> [FitnessFreaks.WeightEntry]? {
    guard let data = userDefaults.data(forKey: weightDataKey) else {
      print("No cached weight data found")
      return nil
    }

    do {
      let decoder = JSONDecoder()
      let entries = try decoder.decode([FitnessFreaks.WeightEntry].self, from: data)
      print("Retrieved \(entries.count) weight entries from cache")
      return entries
    } catch {
      print("Error decoding cached weight data: \(error)")
      return nil
    }
  }

  func getWeightDataTimestamp() -> Date? {
    return userDefaults.object(forKey: "\(weightDataKey)_timestamp") as? Date
  }

  func clearCache() {
    userDefaults.removeObject(forKey: weightDataKey)
  }
}
