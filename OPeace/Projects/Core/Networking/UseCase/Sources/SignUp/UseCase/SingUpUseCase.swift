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
  
  //MARK: -이름 체크
  public func checkNickName(
    _ nickName: String
  ) async throws -> SignUpCheckInfoDTOModel? {
    try await repository.checkNickName(nickName)
  }
  
  //MARK: - 직업에 대한 리스트
  public func fetchJobList() async throws -> SignUpListDTOModel? {
    try await repository.fetchJobList()
  }
  
  //MARK: - 유저정보 업데이트
  public func updateUserInfo(
    nickname: String,
    year: Int,
    job: String,
    generation: String
  ) async throws -> UpdateUserInfoDTOModel? {
    try await repository.updateUserInfo(nickname: nickname, year: year, job: job, generation: generation)
  }
  
  //MARK: - 년도 입력시 세대 확인
  public func checkGeneration(year: Int) async throws -> SignUpCheckInfoDTOModel? {
    try await repository.checkGeneration(year: year)
  }
  
  //MARK: - 세대 리스트
  public func fetchGenerationList() async throws -> SignUpListDTOModel? {
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
