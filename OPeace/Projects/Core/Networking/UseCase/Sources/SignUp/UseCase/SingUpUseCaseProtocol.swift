//
//  SingUpUseCaseProtocol.swift
//  UseCase
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

import Model

public protocol SignUpUseCaseProtocol {
    func checkNickName(_ nickName: String) async throws -> CheckNickNameModel?
    func fetchJobList ()  async throws -> SignUpJobModel?
    func updateUserInfo(
        nickname: String,
        year: Int,
        job: String,
        generation: String
    ) async throws -> UpdateUserInfoModel?
}
