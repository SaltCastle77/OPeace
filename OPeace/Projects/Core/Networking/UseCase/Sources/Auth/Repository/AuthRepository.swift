//
//  AuthRepository.swift
//  UseCase
//
//  Created by 서원지 on 7/23/24.
//

import Foundation
import AuthenticationServices
import Combine

import Moya
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KeychainAccess

import Service
import Foundations
import Utills
import Model


@Observable public class AuthRepository: AuthRepositoryProtocol {
    
    private let provider = MoyaProvider<AuthService>(plugins: [MoyaLoggingPlugin()])
    private let authProvider = MoyaProvider<AuthService>(session: Session(interceptor: AuthInterceptor.shared), plugins: [MoyaLoggingPlugin()])
    
    public init() {}
    
    
    //MARK: - appleLogin
    public func handleAppleLogin(_ requestResult: Result<ASAuthorization, Error>) async throws -> ASAuthorization {
        switch requestResult {
        case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                if let tokenData = appleIDCredential.identityToken,
                   let acessToken = String(data: tokenData, encoding: .utf8) {
                    do {
                        UserDefaults.standard.set(acessToken, forKey: "APPLE_ACCESS_TOKEN")
                        _ = try await appleLogin()
                    } catch {
                        throw error
                    }
                } else {
                    Log.error("Identity token is missing")
                    throw DataError.noData
                }
                return authResults
            default:
                throw DataError.decodingError(NSError(domain: "Invalid Credential", code: 0, userInfo: nil))
            }
            
        case .failure(let error):
            Log.error("Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    //MARK: - 애플로그인 API
    public func appleLogin() async throws -> UserLoginModel? {
        let appleAcessToken = UserDefaults.standard.string(forKey: "APPLE_ACCESS_TOKEN") ?? ""
        return try await provider.requestAsync(.appleLogin(accessToken: appleAcessToken), decodeTo: UserLoginModel.self)
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
                                        Log.error(error.localizedDescription, "requestKakaoTokenAsync")
                                        continuation.resume(throwing: error)
                                        return
                                    }

                                    guard let accessToken = oauthToken?.accessToken else {
                                        continuation.resume(returning: (nil, nil))
                                        return
                                    }

                                    Log.debug("access token", oauthToken?.accessToken ?? "")
                                    
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
                                        Log.error(error.localizedDescription, "requestKakaoTokenAsync")
                                        continuation.resume(throwing: error)
                                        return
                                    }

                                    guard let accessToken = oauthToken?.accessToken else {
                                        continuation.resume(returning: (nil, nil))
                                        return
                                    }
                                    _ = oauthToken
                                    
                                    Log.debug("access token", accessToken)
                                    if accessToken != "" {
                                        UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
                                        UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
                                        UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
                                    } else {
                                        UserDefaults.standard.set(accessToken, forKey: "KAKAO_ACCESS_TOKEN")
                                        UserDefaults.standard.set(accessToken, forKey: "ACCESS_TOKEN")
                                        UserDefaults.standard.set(oauthToken?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
                                    }
                                    Log.debug("access token", oauthToken?.accessToken ?? "")
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
                                Log.debug("access token", oauthToken?.accessToken ?? "")
                                continuation.resume(returning: (accessToken, oauthToken?.idToken))
                                
                            }
                        }
                    }
            } else {
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
                    Log.debug("access token", oauthToken?.idToken ?? "")
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
    public func reauestKakaoLogin() async throws -> UserLoginModel? {
        let kakaoAcessToken = UserDefaults.standard.string(forKey: "KAKAO_ACCESS_TOKEN")
        return try await provider.requestAsync(.kakaoLogin(accessToken: kakaoAcessToken ?? ""), decodeTo: UserLoginModel.self)
    }
    
    //MARK: - 토큰 재발급 API
    public func requestRefreshToken(refreshToken: String) async throws -> RefreshModel? {
        return try await provider.requestAsync(.refreshToken(refreshToken: refreshToken), decodeTo: RefreshModel.self)
    }
    
    //MARK: - 유저정보 조회 API
    public func fetchUserInfo() async throws -> UpdateUserInfoModel? {
        return try await authProvider.requestAsync(.fetchUserInfo, decodeTo: UpdateUserInfoModel.self)
    }
    
    //MARK: - 유저 로그아웃 API
    public func logoutUser(refreshToken: String) async throws -> UserLogOutModel? {
         let refreshToken = UserDefaults.standard.string(forKey: "REFRESH_TOKEN") ?? ""
        return try await authProvider.requestAsync(
            .logoutUser(refreshToken: refreshToken),
            decodeTo: UserLogOutModel.self)
    }
    
    //MARK: - 자동 로그인 API
    public func autoLogin() async throws -> UseLoginModel? {
        return try await authProvider.requestAsync(.autoLogin, decodeTo: UseLoginModel.self)
    }
    
    //MARK: - 회원 탈퇴 API
    public func deleteUser(reason: String) async throws -> DeleteUserModel?  {
        return try await authProvider.requestAsync(.deleteUser(reason: reason), decodeTo: DeleteUserModel.self)
    }

    //MARK: - 유저 토큰 확인 API
    public func checkUserVerify() async throws -> CheckUserVerifyModel? {
        return try await provider.requestAsync(.userVerify, decodeTo: CheckUserVerifyModel.self)
    }
    
    //MARK: - 유저 차단 API
    public func userBlock(
        questioniD: Int,
        userID: String) async throws -> UserBlockModel? {
            return try await authProvider.requestAsync(.userBlock(
                questioniD: questioniD,
                userID: userID), decodeTo: UserBlockModel.self)
        }
    
    //MARK: - 유저 차단 리스트 조회 API
    public func fetchUserBlockList() async throws -> UserBlockListModel? {
        return try await authProvider.requestAsync(.fectchUserBlock, decodeTo: UserBlockListModel.self)
    }
    
    //MARK: - 유저 차단 해제 API
    public func realseUserBlock(userID: String) async throws -> UserBlockModel? {
        return try await authProvider.requestAsync(.realseUserBlock(userID: userID), decodeTo: UserBlockModel.self)
    }
}




