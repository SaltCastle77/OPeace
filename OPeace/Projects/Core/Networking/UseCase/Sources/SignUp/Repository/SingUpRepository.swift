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
    
    public func checkNickName(_ nickName: String) async throws -> CheckNickName? {
        return try await provider.requestAsync(.nickNameCheck(nickname: nickName), decodeTo: CheckNickName.self)
    }
}
