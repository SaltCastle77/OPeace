//
//  VersionComparer.swift
//  UseCase
//
//  Created by Wonji Suh  on 11/12/24.
//

import Foundation
import Foundation

public struct VersionComparer {
  public init() {}
  
  public static func shouldShowUpdatePopup(minimumVersion: String, appStoreVersion: String) -> Bool {
        return minimumVersion.compare(appStoreVersion, options: .numeric) == .orderedDescending
    }
}
