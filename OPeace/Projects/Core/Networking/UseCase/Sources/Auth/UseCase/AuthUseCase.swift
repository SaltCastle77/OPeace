//
//  AuthUseCase.swift
//  UseCase
//
//  Created by 서원지 on 7/23/24.
//

import Foundation
import AuthenticationServices
import ComposableArchitecture
import DiContainer
import Utills
import Model

public struct AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    

    public init(
        repository: AuthRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    
    //MARK: - 애플 로그인
    public func handleAppleLogin(
        _ request: Result<ASAuthorization, Error>
    ) async throws -> ASAuthorization {
        try await repository.handleAppleLogin(request)
    }
    
    //MARK: - 카카오 로그인 토근
    public func requestKakaoTokenAsync() async throws -> (String?, String?) {
        try await repository.requestKakaoTokenAsync()
    }
    
    //MARK: - 카카오 로그인
    public func reauestKakaoLogin() async throws -> KakaoResponse? {
        try await repository.reauestKakaoLogin()
    }
    
}


extension AuthUseCase: DependencyKey {
    public static let liveValue: AuthUseCase = {
        let authRepository = DependencyContainer.live.resolve(AuthRepositoryProtocol.self) ?? DefaultAuthRepository()
         return AuthUseCase(repository: authRepository)
       }()
}
