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
    
    public init() {}
    
    
    //MARK: - appleLogin
    public func handleAppleLogin(_ requestResult: Result<ASAuthorization, Error>) async throws -> ASAuthorization {
        switch requestResult {
        case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                if let tokenData = appleIDCredential.identityToken,
                   let _ = String(data: tokenData, encoding: .utf8) {
                    do {
                        _ = try await provider.requestAsync(.appleLogin, decodeTo: Data.self)
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
                                    try? Keychain().remove("KAKAKO_ID_TOKEN")
                                    try? Keychain().set(accessToken, key: "KAKAKO_ID_TOKEN")
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
                                    try? Keychain().remove("ACCESS_TOKEN")
                                    try? Keychain().set(accessToken, key: "ACCESS_TOKEN")
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
                                try? Keychain().remove("ACCESS_TOKEN")
                                try? Keychain().set(accessToken, key: "ACCESS_TOKEN")
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
                    try? Keychain().set(accessToken, key: "ACCESS_TOKEN")
                    continuation.resume(returning: (accessToken, oauthToken?.idToken))
                }
            }
        }
    }
    
    //MARK: - 카카오 로그인 api
    public func reauestKakaoLogin() async throws -> KakaoResponseModel? {
        let kakaoAcessToken = (try? Keychain().get("ACCESS_TOKEN") ?? "")
        return try await provider.requestAsync(.kakaoLogin( accessToken: kakaoAcessToken ?? ""), decodeTo: KakaoResponseModel.self)
    }
    
    //MARK: - 토큰 재발급
    public func requestRefreshToken(refreshToken: String) async throws -> RefreshModel? {
        return try await provider.requestAsync(.refreshToken(refreshToken: refreshToken), decodeTo: RefreshModel.self)
    }
    
    //MARK: - 유저정보 조회
    public func fetchUserInfo() async throws -> UpdateUserInfoModel? {
        return try await provider.requestAsync(.fetchUserInfo, decodeTo: UpdateUserInfoModel.self)
    }
}




