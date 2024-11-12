//
//  Extension+KakaoResponseModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

public extension UserLoginModel {
  func toOAuthDTOModel() -> OAuthDTOModel {
    let data: OAuthReponseDTOModel = .init(
      accessToken: self.data?.accessToken ?? "",
      refreshToken: self.data?.refreshToken ?? ""
    )
    
    return OAuthDTOModel(data: data)
  }
  
}
