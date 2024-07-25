//
//  SingUpUseCaseProtocol.swift
//  UseCase
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

import Model

public protocol SignUpUseCaseProtocol {
    func checkNickName(_ nickName: String) async throws -> CheckNickName?
}
