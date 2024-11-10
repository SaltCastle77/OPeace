//
//  DefaultAuthRepository.swift
//  UseCase
//
//  Created by 서원지 on 7/23/24.
//


import Foundation
import AuthenticationServices
import Model
import Utills

public final class DefaultAuthRepository: AuthRepositoryProtocol {
  
  
  public init() {}
  
  public func handleAppleLogin(_ requestResult: Result<ASAuthorization, Error>) async throws -> ASAuthorization {
    return try await withCheckedThrowingContinuation { continuation in
      switch requestResult {
      case .success(let request):
        break
      case .failure(let error):
        continuation.resume(throwing: error)
      }
    }
  }
  
  public func appleLogin() async throws -> OAuthDTOModel? {
    return  nil
  }
  
  
  public func requestKakaoTokenAsync() async throws -> (String?, String?) {
    return (nil, nil)
  }
  
  public func reauestKakaoLogin() async throws -> OAuthDTOModel? {
    return nil
  }
  
  public func requestRefreshToken(
    refreshToken: String
  ) async throws -> RefreshDTOModel? {
    return nil
  }
  
  public func fetchUserInfo() async throws -> UpdateUserInfoModel? {
    return nil
  }
  
  
  public func logoutUser(refreshToken: String) async throws -> UserDTOModel? {
    return nil
  }
  
  public func autoLogin() async throws -> UserDTOModel? {
    return nil
  }
  
  public func deleteUser(reason: String) async throws -> DeletUserDTOModel?{
    return nil
  }
  
  public func checkUserVerify() async throws -> CheckUserDTOModel? {
    return nil
  }
  
  public func userBlock(questioniD: Int, userID: String) async throws -> UserBlockModel? {
    return nil
  }
  
  public func fetchUserBlockList() async throws -> UserBlockListModel? {
    return nil
  }
  
  public func realseUserBlock(userID: String) async throws -> UserBlockModel? {
    return nil
  }
  
  public func makeJWT() async throws -> String {
    return ""
  }
  
  public func getAppleRefreshToken(code: String) async throws -> OAuthDTOModel? {
    return nil
  }
  
  public func revokeAppleToken() async throws -> OAuthDTOModel? {
    return nil
  }
}
