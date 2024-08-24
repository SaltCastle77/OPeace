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
    func appleLogin() async throws -> UserLoginModel?
    func requestKakaoTokenAsync() async throws  -> (String?, String?)
    func reauestKakaoLogin() async throws -> UserLoginModel?
    func requestRefreshToken(refreshToken : String) async throws -> RefreshModel?
    func fetchUserInfo() async throws -> UpdateUserInfoModel?
    func logoutUser(refreshToken : String) async throws -> UserLogOutModel?
    func autoLogin() async throws -> UseLoginModel?
    func deleteUser(reason: String) async throws -> DeleteUserModel?
    func checkUserVerify() async throws -> CheckUserVerifyModel?
}
