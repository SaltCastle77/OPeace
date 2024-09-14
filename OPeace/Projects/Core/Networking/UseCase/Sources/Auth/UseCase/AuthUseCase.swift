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
    
    
    //MARK: - 애플 로그인 토큰
    public func handleAppleLogin(
        _ request: Result<ASAuthorization, Error>
    ) async throws -> ASAuthorization {
        try await repository.handleAppleLogin(request)
    }
    
    //MARK: - 애플 로그인
    public func appleLogin() async throws -> UserLoginModel? {
        try await repository.appleLogin()
    }
    
    //MARK: - 애플 JWT 만들기
    public func makeJWT() async throws -> String {
        try await repository.makeJWT()
    }
    
    //MARK: - 애플 토큰 발급
    public func getAppleRefreshToken(
        code: String
    ) async throws -> AppleTokenResponse? {
        try await repository.getAppleRefreshToken(code: code)
    }
    
    //MARK: - 애플 회원 탈퇴
    public func revokeAppleToken() async throws -> AppleTokenResponse? {
        try await repository.revokeAppleToken()
    }
    
    //MARK: - 카카오 로그인 토근
    public func requestKakaoTokenAsync() async throws -> (String?, String?) {
        try await repository.requestKakaoTokenAsync()
    }
    
    //MARK: - 카카오 로그인
    public func reauestKakaoLogin() async throws -> UserLoginModel? {
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
    
    //MARK: - 유저 차단
    public func userBlock(
        questioniD: Int,
        userID: String
    ) async throws -> UserBlockModel? {
        try await repository.userBlock(questioniD: questioniD, userID: userID)
    }
    
    //MARK: - 유저차단 목록
    public func fetchUserBlockList() async throws -> UserBlockListModel? {
        try await repository.fetchUserBlockList()
    }
    
    //MARK: - 유저 차단 해제
    public func realseUserBlock(userID: String) async throws -> UserBlockModel? {
        try await repository.realseUserBlock(userID: userID)
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
