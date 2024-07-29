//
//  SignUpRepositoryProtocol.swift
//  UseCase
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

import Model

public protocol SignUpRepositoryProtocol {
    func checkNickName(_ nickName: String) async throws -> CheckNickNameModel?
    func fetchJobList ()  async throws -> SignUpJobModel?
}
