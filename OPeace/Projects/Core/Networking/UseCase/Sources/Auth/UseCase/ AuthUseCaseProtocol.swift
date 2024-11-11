//
//   AuthUseCaseProtocol.swift
//  UseCase
//
//  Created by 서원지 on 7/23/24.
//

import Foundation
import AuthenticationServices
import Utills
import Model

public protocol AuthUseCaseProtocol {
  func handleAppleLogin(_ request: Result<ASAuthorization, Error>) async throws -> ASAuthorization
  func requestKakaoTokenAsync() async throws  -> (String?, String?)
  func appleLogin() async throws -> OAuthDTOModel?
  func reauestKakaoLogin() async throws -> OAuthDTOModel?
  func requestRefreshToken(refreshToken : String) async throws -> RefreshDTOModel?
  func fetchUserInfo() async throws -> UpdateUserInfoModel?
  func logoutUser(refreshToken : String) async throws -> UserDTOModel?
  func autoLogin() async throws -> UserDTOModel?
  func deleteUser(reason: String) async throws -> DeletUserDTOModel?
  func checkUserVerify() async throws -> CheckUserDTOModel?
  func userBlock(questioniD: Int, userID: String) async throws -> UserBlockDTOModel?
  func fetchUserBlockList() async throws -> UserBlockListDTOModel?
  func realseUserBlock(userID: String) async throws -> UserBlockDTOModel?
  func makeJWT() async throws -> String
  func getAppleRefreshToken(code: String) async throws -> OAuthDTOModel?
  func revokeAppleToken() async throws -> OAuthDTOModel?
}
