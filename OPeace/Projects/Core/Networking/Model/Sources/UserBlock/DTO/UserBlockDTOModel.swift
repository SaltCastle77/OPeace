//
//  UserBlockDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public struct UserBlockDTOModel: Codable, Equatable {
  let data: UserBlockResponseDTOModel
  
  public init(
    data: UserBlockResponseDTOModel
  ) {
    self.data = data
  }
}
 

public struct UserBlockResponseDTOModel: Codable, Equatable {
  public let status: Bool
  public let message: String
  
  public init(
    status: Bool,
    message: String
  ) {
    self.status = status
    self.message = message
  }
}
