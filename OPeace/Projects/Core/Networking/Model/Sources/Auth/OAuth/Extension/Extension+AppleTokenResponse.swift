//
//  Extension+AppleTokenResponse.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public extension AppleTokenResponse {
  func toOAuthDTOToModel() -> OAuthDTOModel {
    let data: OAuthReponseDTOModel = .init(
      accessToken: self.access_token ?? "",
      refreshToken: self.refresh_token ?? "")
    
    return OAuthDTOModel(data: data)
  }
}
