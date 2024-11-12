//
//  DefaultSingUpRepository.swift
//  UseCase
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

import Model

public final class DefaultSignUpRepository: SignUpRepositoryProtocol {
  
  public init() {
    
  }
  
  public func checkNickName(_ nickName: String) async throws -> SignUpCheckInfoDTOModel? {
    return nil
  }
  
  public func fetchJobList() async throws -> SignUpListDTOModel? {
    return nil
  }
  
  public func updateUserInfo(
    nickname: String,
    year: Int,
    job: String,
    generation: String
  ) async throws -> UpdateUserInfoDTOModel? {
    return nil
  }
  
  public func checkGeneration(year: Int) async throws -> SignUpCheckInfoDTOModel? {
    return nil
  }
  
  public func fetchGenerationList() async throws -> SignUpListDTOModel? {
    nil
  }
}
