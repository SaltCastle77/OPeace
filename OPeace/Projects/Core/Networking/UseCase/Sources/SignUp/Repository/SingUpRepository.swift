//
//  SingUpRepository.swift
//  UseCase
//
//  Created by 서원지 on 7/25/24.
//

import Foundation
import Combine

import Model
import Service
import AsyncMoya

@Observable public class SingUpRepository: SignUpRepositoryProtocol {
  private let provider = MoyaProvider<SignUpService>(plugins: [MoyaLoggingPlugin()])
  
  public init() {
    
  }
  
  //MARK: - 이름 중복 체크
  public func checkNickName(_ nickName: String) async throws -> SignUpCheckInfoDTOModel? {
    let checkNickNameModel = try await provider.requestAsync(.nickNameCheck(nickname: nickName), decodeTo: CheckNickNameModel.self)
    return checkNickNameModel.toSignUPInfoDTOToModel()
  }
  
  //MARK: - 직업 정보 API
  public func fetchJobList() async throws -> SignUpListDTOModel? {
    let jobListModel = try await provider.requestAsync(.signUpJob, decodeTo: SignUpJobModel.self)
    return jobListModel.toSignUPListDTOToModel()
  }
  
  public func fetchGenerationList() async throws -> SignUpListDTOModel? {
    let generationListModel = try await provider.requestAsync(.getGenerationList, decodeTo: GenerationListResponse.self)
    return generationListModel.toGenerationListDTOToModel()
  }
  
  //MARK: - 유저 정보 업데이트
  public func updateUserInfo(
    nickname: String,
    year: Int,
    job: String,
    generation: String
  ) async throws -> UpdateUserInfoDTOModel? {
    let updateUserInfoModel = try await provider.requestAsync(.updateUserInfo(
      nickname: nickname,
      year: year,
      job: job,
      generation: generation
    ), decodeTo: UpdateUserInfoModel.self)
    return updateUserInfoModel.toUpdateUserInfoDTOToModel()
  }
  
  //MARK: -  년도 입력시 세대 확인 API
  public func checkGeneration(year: Int) async throws -> SignUpCheckInfoDTOModel? {
    let chekcGenrationModel = try await provider.requestAsync(.checkGeneration(
      year: year
    ), decodeTo: CheckGeneraionModel.self)
    return chekcGenrationModel.toSignUpInfoDTOToModel()
  }
}
