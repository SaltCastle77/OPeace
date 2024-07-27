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
    
    public func checkNickName(_ nickName: String) async throws -> CheckNickName? {
        return nil
    }
    
    public func fetchJobList() async throws -> SignUpJobModel? {
        return nil
    }
}
