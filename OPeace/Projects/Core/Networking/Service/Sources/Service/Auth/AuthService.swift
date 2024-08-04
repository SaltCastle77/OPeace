//
//  AuthService.swift
//  Service
//
//  Created by 서원지 on 7/23/24.
//

import Foundation
import Moya
import API
import Foundations

public enum AuthService {
    case appleLogin
    case kakaoLogin(accessToken: String)
    case refreshToken(refreshToken: String)
    case fetchUserInfo
    case logoutUser(refreshToken: String)
    case autoLogin
    case deleteUser
}

extension AuthService: BaseTargetType {
    public var path: String {
        switch self {
        case .appleLogin:
            return AuthAPI.appleLogin.authAPIDesc
            
        case .kakaoLogin:
            return AuthAPI.kakaoLoginCallback.authAPIDesc
            
        case .refreshToken:
            return AuthAPI.refreshToken.authAPIDesc
            
        case .fetchUserInfo:
            return AuthAPI.fetchUser.authAPIDesc
            
        case .logoutUser:
            return AuthAPI.logoutUser.authAPIDesc
            
        case .autoLogin:
            return AuthAPI.autoLogin.authAPIDesc
            
        case .deleteUser:
            return AuthAPI.deleteUser.authAPIDesc
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .appleLogin:
            return .get
            
        case .kakaoLogin:
            return .get
            
        case .refreshToken:
            return .post
            
        case .fetchUserInfo:
            return .get
            
        case .logoutUser:
            return .post
            
        case .autoLogin:
            return .post
            
        case .deleteUser:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .appleLogin:
            return .requestPlain
            
        case .kakaoLogin(let accessToken):
            let parameters: [String: Any] = [
                "access_token": accessToken
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .refreshToken(let refreshToken):
            let parameters: [String: Any] = [
                "refresh_token": refreshToken
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .fetchUserInfo:
            return .requestPlain
            
        case .logoutUser(let refreshToken):
            let parameters: [String: Any] = [
                "refresh_token" : refreshToken
                ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .autoLogin:
            let parameters: [String: Any] = [:]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .deleteUser:
            let parameters: [String: Any] = [
                 :
                ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .kakaoLogin:
            return APIHeader.notAccessTokenHeader
            
            
        default:
            return APIHeader.baseHeader
        }
    }
}
