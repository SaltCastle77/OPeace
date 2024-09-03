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
import Utills

import Moya


@Observable public class SingUpRepository: SignUpRepositoryProtocol {
    private let provider = MoyaProvider<SignUpService>(plugins: [MoyaLoggingPlugin()])
    
    public init() {
        
    }
    
    //MARK: - 이름 중복 체크
    public func checkNickName(_ nickName: String) async throws -> CheckNickNameModel? {
        return try await provider.requestAsync(.nickNameCheck(nickname: nickName), decodeTo: CheckNickNameModel.self)
    }
    
    //MARK: - 직업 정보 API
    public func fetchJobList() async throws -> SignUpJobModel? {
        return  try await provider.requestAsync(.signUpJob, decodeTo: SignUpJobModel.self)
    }
    
    public func fetchGenerationList() async throws -> GenerationListResponse? {
        return try await provider.requestAsync(.getGenerationList, decodeTo: GenerationListResponse.self)
    }
    
    //MARK: - 유저 정보 업데이트
    public func updateUserInfo(
        nickname: String,
        year: Int,
        job: String,
        generation: String
    ) async throws -> UpdateUserInfoModel? {
        return try await provider.requestAsync(.updateUserInfo(
            nickname: nickname,
            year: year,
            job: job,
            generation: generation
        ), decodeTo: UpdateUserInfoModel.self)
    }
    
    //MARK: -  년도 입력시 세대 확인 API
    public func checkGeneration(year: Int) async throws -> CheckGeneraionModel? {
        return try await provider.requestAsync(.checkGeneration(
            year: year
        ), decodeTo: CheckGeneraionModel.self)
    }
}
