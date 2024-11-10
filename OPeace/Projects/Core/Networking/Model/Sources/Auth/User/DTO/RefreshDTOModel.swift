//
//  RefreshDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public struct RefreshDTOModel: Codable, Equatable {
  public let data: RefreshResponseDTOModel
  
  public init(data: RefreshResponseDTOModel) {
    self.data = data
  }
}

public struct RefreshResponseDTOModel: Codable, Equatable {
  public let accessToken, refreshToken: String
  
  public init(
    accessToken: String,
    refreshToken: String
  ) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
