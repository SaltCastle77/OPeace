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
    
    public func checkNickName(_ nickName: String) async throws -> CheckNickNameModel? {
        return try await provider.requestAsync(.nickNameCheck(nickname: nickName), decodeTo: CheckNickNameModel.self)
    }
    
    public func fetchJobList() async throws -> SignUpJobModel? {
        return  try await provider.requestAsync(.signUpJob, decodeTo: SignUpJobModel.self)
    }
    
    public func updateUserInfo(nickname: String, year: Int, job: String, generation: String) async throws -> UpdateUserInfoModel? {
        return try await provider.requestAsync(.updateUserInfo(
            nickname: nickname,
            year: year,
            job: job,
            generation: generation
        ), decodeTo: UpdateUserInfoModel.self)
    }
}
