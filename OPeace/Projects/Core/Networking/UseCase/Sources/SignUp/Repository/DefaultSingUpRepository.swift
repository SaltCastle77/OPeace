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
    
    public func checkNickName(_ nickName: String) async throws -> CheckNickNameModel? {
        return nil
    }
    
    public func fetchJobList() async throws -> SignUpJobModel? {
        return nil
    }
    
    public func updateUserInfo(
        nickname: String,
        year: Int,
        job: String,
        generation: String
    ) async throws -> UpdateUserInfoModel? {
        return nil
    }
    
    public func checkGeneration(year: Int) async throws -> CheckGeneraionModel? {
        return nil
    }
}
