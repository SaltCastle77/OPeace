//
//  AuthAPIManger.swift
//  UseCase
//
//  Created by 서원지 on 8/30/24.
//

import Model
import Foundation
import API
import Alamofire
import Foundations
import AsyncMoya

public final class AuthAPIManger {
  public static let shared = AuthAPIManger()
  var loginModel: RefreshDTOModel? = nil
  let repository = AuthRepository()
  
  public init() {}
  
  public func refeshTokenRsponse(_ result: Result<RefreshDTOModel, CustomError>) -> Result<RefreshDTOModel, CustomError>  {
    switch result {
    case .success(let refeshModel):
      self.loginModel = refeshModel
      APIHeader.accessTokenKey = refeshModel.data.accessToken
      APIHeader.refreshTokenKey = refeshModel.data.refreshToken
      UserDefaults.standard.set(refeshModel.data.accessToken, forKey: "ACCESS_TOKEN")
      UserDefaults.standard.set(refeshModel.data.refreshToken, forKey: "REFRESH_TOKEN")
      return .success(refeshModel)
    case .failure(let error):
      #logError("리프레쉬 에러", error.localizedDescription)
      return .failure(error)
    }
  }
  
  public func getRefeshToken() async  -> RetryResult  {
    let authResultData = await Result {
      try await repository.requestRefreshToken(refreshToken: APIHeader.refreshTokenKey)
    }
    
    switch authResultData {
    case .success(let authResultData):
      if let authResultData = authResultData {
        _ = self.refeshTokenRsponse(.success(authResultData))
        return .retry
      } else {
        let error = CustomError.tokenError("AuthResultData is nil")
        _ = refeshTokenRsponse(.failure(error))
        return .doNotRetryWithError(error)
      }
      
    case .failure(let error):
      _ = refeshTokenRsponse(.failure(CustomError.tokenError(error.localizedDescription)))
      return .doNotRetryWithError(error)
    }
  }
}
