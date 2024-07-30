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
    
}
