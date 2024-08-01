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
            let parameters: [String: Any] = [:]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
