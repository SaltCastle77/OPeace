//
//  AuthRepositoryProtocol.swift
//  UseCase
//
//  Created by 서원지 on 7/23/24.
//

import Foundation
import AuthenticationServices
import Utills
import Model

public protocol AuthRepositoryProtocol {
    func handleAppleLogin(_ request: Result<ASAuthorization, Error>) async throws -> ASAuthorization
    func requestKakaoTokenAsync() async throws  -> (String?, String?)
    func reauestKakaoLogin() async throws -> KakaoResponseModel?
}
