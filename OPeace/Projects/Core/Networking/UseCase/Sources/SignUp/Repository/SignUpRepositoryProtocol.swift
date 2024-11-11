//
//  SignUpRepositoryProtocol.swift
//  UseCase
//
//  Created by 서원지 on 7/25/24.
//

import Foundation
import Model

public protocol SignUpRepositoryProtocol {
  func checkNickName(_ nickName: String) async throws -> SignUpCheckInfoDTOModel?
  func fetchJobList()  async throws -> SignUpListDTOModel?
  func fetchGenerationList() async throws -> GenerationListResponse?
  func updateUserInfo(
    nickname: String,
    year: Int,
    job: String,
    generation: String
  ) async throws -> UpdateUserInfoModel?
  func checkGeneration(year: Int) async throws -> SignUpCheckInfoDTOModel?
}
