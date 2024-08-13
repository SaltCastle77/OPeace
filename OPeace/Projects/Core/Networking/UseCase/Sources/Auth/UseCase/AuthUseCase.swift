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
    public func reauestKakaoLogin() async throws -> KakaoResponseModel? {
        try await repository.reauestKakaoLogin()
    }
    
    //MARK: - 리프레쉬토큰 재발급
    public func requestRefreshToken(
        refreshToken: String
    ) async throws -> RefreshModel? {
        try await repository.requestRefreshToken(refreshToken: refreshToken)
    }
    
    //MARK: - 유저 정보 조회
    public func fetchUserInfo() async throws -> UpdateUserInfoModel? {
        try await repository.fetchUserInfo()
    }
    
    //MARK: - 유저 로그아웃
    public func logoutUser(refreshToken: String) async throws -> UserLogOutModel? {
        try await repository.logoutUser(refreshToken: refreshToken)
    }
    
    //MARK: - 자동 로그인
    public func autoLogin() async throws -> UseLoginModel? {
        try await repository.autoLogin()
    }
    
    //MARK: - 회원탈퇴
    public func deleteUser(reason: String) async throws -> DeleteUserModel? {
        try await repository.deleteUser(reason: reason)
    }
    
    //MARK: - 유저 토큰 확인
    public func checkUserVerify() async throws -> CheckUserVerifyModel? {
        try await repository.checkUserVerify()
    }
}


extension AuthUseCase: DependencyKey {
    public static let liveValue: AuthUseCase = {
        let authRepository = DependencyContainer.live.resolve(AuthRepositoryProtocol.self) ?? DefaultAuthRepository()
        return AuthUseCase(repository: authRepository)
    }()
}

public extension DependencyValues {
    var authUseCase: AuthUseCaseProtocol {
        get { self[AuthUseCase.self] }
        set { self[AuthUseCase.self] = newValue as! AuthUseCase}
    }
}
