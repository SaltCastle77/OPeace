//
//  AuthRepository.swift
//  UseCase
//
//  Created by 서원지 on 7/23/24.
//

import Foundation
import AuthenticationServices
import Combine

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

import Service
import ThirdPartys
import AsyncMoya
import Model
import SwiftJWT


@Observable public class AuthRepository: AuthRepositoryProtocol {
  
  private let provider = MoyaProvider<AuthService>(plugins: [MoyaLoggingPlugin()])
  private let authProvider = MoyaProvider<AuthService>(session: Session(interceptor: AuthInterceptor.shared), plugins: [MoyaLoggingPlugin()])
  private let appleProvider = MoyaProvider<AppleAuthService>(plugins: [MoyaLoggingPlugin()])
  
  public init() {}
  
  
  //MARK: - appleLogin
  public func handleAppleLogin(_ requestResult: Result<ASAuthorization, Error>) async throws -> ASAuthorization {
    switch requestResult {
    case .success(let authResults):
      switch authResults.credential {
      case let appleIDCredential as ASAuthorizationAppleIDCredential:
        if let tokenData = appleIDCredential.identityToken,
           let acessToken = String(data: tokenData, encoding: .utf8),
           let authorizationCode = appleIDCredential.authorizationCode{
          do {
            let code = String(decoding: authorizationCode, as: UTF8.self)
            UserDefaults.standard.set(code, forKey: "APPLE_ACCESS_CODE")
            UserDefaults.standard.set(acessToken, forKey: "APPLE_ACCESS_TOKEN")
            _ = try await appleLogin()
            
          } catch {
            throw error
          }
        } else {
          #logError("Identity token is missing")
          throw DataError.noData
        }
        return authResults
      default:
        throw DataError.decodingError(NSError(domain: "Invalid Credential", code: 0, userInfo: nil))
      }
      
    case .failure(let error):
      #logError("Error: \(error.localizedDescription)")
      throw error
    }
  }
  
  //MARK: - 애플로그인 API
  public func appleLogin() async throws -> OAuthDTOModel? {
    let appleAcessToken = UserDefaults.standard.string(forKey: "APPLE_ACCESS_TOKEN") ?? ""
    let userLoginModel =  try await provider.requestAsync(.appleLogin(accessToken: appleAcessToken), decodeTo: UserLoginModel.self)
    return userLoginModel.toOAuthDTOModel()
  }
  
  //MARK: - 애플로그인 JWT
  public func makeJWT() async throws -> String {
    let myHeader = Header(kid: "UGLKH5D2RL")
    
    // MARK: - client_secret(JWT) 발급 응답 모델
    struct MyClaims: Claims {
      let iss: String
      let iat: Int
      let exp: Int
      let aud: String
      let sub: String
    }
    
    var dateComponent = DateComponents()
    dateComponent.month = 6
    let iat = Int(Date().timeIntervalSince1970)
    let exp = iat + 3600
    let myClaims = MyClaims(iss: "N94CS4N6VR",
                            iat: iat,
                            exp: exp,
                            aud: "https://appleid.apple.com",
                            sub: "io.Opeace.Opeace")
    
    var myJWT = JWT(header: myHeader, claims: myClaims)
    guard let url = Bundle.main.url(forResource: "AuthKey_UGLKH5D2RL", withExtension: "p8"),
          let privateKey: Data = try? Data(contentsOf: url, options: .alwaysMapped),
          let signedJWT = try? myJWT.sign(using: JWTSigner.es256(privateKey: privateKey))
    else {
      return ""
    }
    UserDefaults.standard.set(signedJWT, forKey: "AppleClientSecret")
    #logDebug("🗝 singedJWT -", signedJWT)
    return signedJWT
  }
  
  //MARK: - 애플로그인 토큰 발급
  public func getAppleRefreshToken(code: String) async throws -> OAuthDTOModel? {
    let clientSecret = try await makeJWT()
    let appleResponseModel = try await appleProvider.requestAsync(.getRefreshToken(code: code, clientSecret: clientSecret), decodeTo: AppleTokenResponse.self)
    return appleResponseModel.toOAuthDTOToModel()
  }
  
  //MARK: - 애플 탈퇴
  public func revokeAppleToken() async throws -> OAuthDTOModel? {
    let clientSecret = UserDefaults.standard.string(forKey: "AppleClientSecret") ?? ""
    let token = UserDefaults.standard.string(forKey: "APPLE_REFRESH_TOKEN") ?? ""
    let appleResponseModel = try await appleProvider.requestAsync(.revokeToken(clientSecret: clientSecret, token: token), decodeTo: AppleTokenResponse.self)
    return appleResponseModel.toOAuthDTOToModel()
  }
  
  //MARK: - kakaoLoigin
  public func requestKakaoTokenAsync() async throws -> (String?, String?) {
    return try await withCheckedThrowingContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
          if let error = error {
            if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
              UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                  #logError(error.localizedDescription, "requestKakaoTokenAsync")
                  continuation.resume(throwing: error)
                  return
                }
                
                guard let accessToken = oauthToken?.accessToken else {
                  continuation.resume(returning: (nil, nil))
                  return
                }
                
                #logDebug("access token", oauthToken?.accessToken ?? "")
                
                if accessToken != "" {
                  UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
                  UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
                  UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
                } else {
                  UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
                  UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
                  UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
                }
                
                continuation.resume(returning: (accessToken, oauthToken?.idToken))
              }
            }
            else {
              UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                  #logError(error.localizedDescription, "requestKakaoTokenAsync")
                  continuation.resume(throwing: error)
                  return
                }
                
                guard let accessToken = oauthToken?.accessToken else {
                  continuation.resume(returning: (nil, nil))
                  return
                }
                _ = oauthToken
                
                #logDebug("access token", accessToken)
                if accessToken != "" {
                  UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
                  UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
                  UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
                } else {
                  UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
                  UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
                  UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
                }
                #logDebug("access token", oauthToken?.accessToken ?? "")
                continuation.resume(returning: (accessToken, oauthToken?.idToken))
              }
            }
          }
          else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
              if let error = error {
                Log.error(error.localizedDescription, "requestKakaoTokenAsync")
                continuation.resume(throwing: error)
                return
              }
              
              guard let accessToken = oauthToken?.accessToken else {
                continuation.resume(returning: (nil, nil))
                return
              }
              _ = oauthToken
              if accessToken != "" {
                UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
                UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
                UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
              } else {
                UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
                UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
                UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
              }
              #logDebug("access token", oauthToken?.accessToken ?? "")
              continuation.resume(returning: (accessToken, oauthToken?.idToken))
              
            }
          }
        }
      } else {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
          if let error = error {
            #logError(error.localizedDescription, "requestKakaoTokenAsync")
            continuation.resume(throwing: error)
            return
          }
          
          guard let accessToken = oauthToken?.accessToken else {
            continuation.resume(returning: (nil, nil))
            return
          }
          
          _ = oauthToken
          #logDebug("access token", oauthToken?.idToken ?? "")
          if accessToken != "" {
            UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
            UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
            UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
          } else {
            UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
            UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
          }
          continuation.resume(returning: (accessToken, oauthToken?.idToken))
        }
      }
    }
  }
  
  
  //MARK: - 카카오 로그인 API
  public func reauestKakaoLogin() async throws -> OAuthDTOModel? {
    let kakaoAcessToken = UserDefaults.standard.string(forKey: "KAKAO_ACCESS_TOKEN")
    let userLoginModel = try await provider.requestAsync(.kakaoLogin(accessToken: kakaoAcessToken ?? ""), decodeTo: UserLoginModel.self)
    return userLoginModel.toOAuthDTOModel()
    
  }
  
  //MARK: - 토큰 재발급 API
  public func requestRefreshToken(refreshToken: String) async throws -> RefreshDTOModel? {
    let refershModel = try await provider.requestAsync(.refreshToken(refreshToken: refreshToken), decodeTo: RefreshModel.self)
    return refershModel.toRefreshDTOToModel()
  }
  
  //MARK: - 유저정보 조회 API
  public func fetchUserInfo() async throws -> UpdateUserInfoModel? {
    return try await authProvider.requestAsync(.fetchUserInfo, decodeTo: UpdateUserInfoModel.self)
  }
  
  //MARK: - 유저 로그아웃 API
  public func logoutUser(refreshToken: String) async throws -> UserDTOModel? {
    let refreshToken = UserDefaults.standard.string(forKey: "REFRESH_TOKEN") ?? ""
    let userLogOutModel = try await authProvider.requestAsync(
      .logoutUser(refreshToken: refreshToken),
      decodeTo: UserLogOutModel.self)
    return userLogOutModel.toUserDTOToModel()
  }
  
  //MARK: - 자동 로그인 API
  public func autoLogin() async throws -> UserDTOModel? {
    let userLoginModel = try await authProvider.requestAsync(.autoLogin, decodeTo: UseLoginModel.self)
    return userLoginModel.userDTOToModel()
  }
  
  //MARK: - 회원 탈퇴 API
  public func deleteUser(reason: String) async throws -> DeletUserDTOModel?  {
    let deleteUserModel = try await authProvider.requestAsync(.deleteUser(reason: reason), decodeTo: DeleteUserModel.self)
    return deleteUserModel.toDeleteUserDTOToModel()
  }
  
  //MARK: - 유저 토큰 확인 API
  public func checkUserVerify() async throws -> CheckUserDTOModel? {
    let chekcUserVerfiyModel = try await provider.requestAsync(.userVerify, decodeTo: CheckUserVerifyModel.self)
    return chekcUserVerfiyModel.toCheckUserDTOModel()
  }
  
  //MARK: - 유저 차단 API
  public func userBlock(
    questioniD: Int,
    userID: String
  ) async throws -> UserBlockDTOModel? {
    let userBlockModel = try await authProvider.requestAsync(.userBlock(
      questioniD: questioniD,
      userID: userID), decodeTo: UserBlockModel.self)
    return userBlockModel.toUserBlockDTOToModel()
  }
  
  //MARK: - 유저 차단 리스트 조회 API
  public func fetchUserBlockList() async throws -> UserBlockListDTOModel? {
    let userBlockListModel = try await authProvider.requestAsync(.fectchUserBlock, decodeTo: UserBlockListModel.self)
    return userBlockListModel.toUserBlockLIstDTOToModel()
  }
  
  //MARK: - 유저 차단 해제 API
  public func realseUserBlock(userID: String) async throws -> UserBlockDTOModel? {
    let userBlockModel = try await authProvider.requestAsync(.realseUserBlock(userID: userID), decodeTo: UserBlockModel.self)
    return userBlockModel.toUserBlockDTOToModel()
  }
}




