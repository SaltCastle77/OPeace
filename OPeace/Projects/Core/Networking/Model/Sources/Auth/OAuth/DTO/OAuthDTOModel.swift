//
//  OAuthDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public struct OAuthDTOModel: Codable, Equatable {
  public let data: OAuthReponseDTOModel
  
  public init(
    data: OAuthReponseDTOModel
  ) {
    self.data = data
  }
}

public struct OAuthReponseDTOModel: Codable, Equatable {
  public let accessToken: String
  public let refreshToken: String
  
  
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}
