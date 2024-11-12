//
//  AppStoreVersionFetcher.swift
//  UseCase
//
//  Created by Wonji Suh  on 11/12/24.
//

import Foundation
import FirebaseRemoteConfig

public actor AppStoreVersionFetcher {
  public init() {}
  
  public static func fetchAppStoreVersion(bundleID: String) async throws -> String {
    guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
      throw URLError(.badURL)
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
       let results = json["results"] as? [[String: Any]],
       let appInfo = results.first,
       let appStoreVersion = appInfo["version"] as? String {
      return appStoreVersion
    } else {
      throw NSError(
        domain: "AppStoreError",
        code: -1,
        userInfo: [NSLocalizedDescriptionKey: "Failed to parse App Store response."]
      )
    }
  }
}
