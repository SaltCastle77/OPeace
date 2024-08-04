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
    
    public func requestKakaoTokenAsync() async throws -> (String?, String?) {
        return (nil, nil)
    }
    
    public func reauestKakaoLogin() async throws -> KakaoResponseModel? {
        return nil
    }
    
    public func requestRefreshToken(
        refreshToken: String
    ) async throws -> RefreshModel? {
        return nil
    }
    
    public func fetchUserInfo() async throws -> UpdateUserInfoModel? {
        return nil
    }
    
    
    public func logoutUser(refreshToken: String) async throws -> UserLogOutModel? {
        return nil
    }
    
    public func autoLogin() async throws -> UseLoginModel? {
        return nil
    }
    
    public func deleteUser() async throws -> DeleteUserModel?{
        return nil
    }
}
