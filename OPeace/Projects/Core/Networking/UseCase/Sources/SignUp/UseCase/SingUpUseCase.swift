//
//  SingUpUseCase.swift
//  UseCase
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

import ComposableArchitecture

import Model
import DiContainer

public struct SignUpUseCase : SignUpUseCaseProtocol{
    private let repository: SignUpRepositoryProtocol
    
    
    public init(
        repository: SignUpRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    
    public func checkNickName(
        _ nickName: String
    ) async throws -> CheckNickNameModel? {
        try await repository.checkNickName(nickName)
    }
    
    public func fetchJobList() async throws -> SignUpJobModel? {
        try await repository.fetchJobList()
    }
    
    //MARK: - 유저정보 업데이트
    public func updateUserInfo(
        nickname: String,
        year: Int,
        job: String,
        generation: String
    ) async throws -> UpdateUserInfoModel? {
        try await repository.updateUserInfo(nickname: nickname, year: year, job: job, generation: generation)
    }
    
    //MARK: - 년도 입력시 세대 확인
    public func checkGeneration(year: Int) async throws -> CheckGeneraionModel? {
        try await repository.checkGeneration(year: year)
    }
    
    public func fetchGenerationList() async throws -> GenerationListResponse? {
        try await repository.fetchGenerationList()
    }
}


extension SignUpUseCase: DependencyKey {
    public static let liveValue: SignUpUseCase = {
        let authRepository = DependencyContainer.live.resolve(SignUpRepositoryProtocol.self) ?? DefaultSignUpRepository()
         return SignUpUseCase(repository: authRepository)
       }()
}

public extension DependencyValues {
    var signUpUseCase: SignUpUseCaseProtocol {
        get { self[SignUpUseCase.self] }
        set { self[SignUpUseCase.self] = newValue as! SignUpUseCase}
    }
}
