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
}

extension AuthService: BaseTargetType {
    public var path: String {
        switch self {
        case .appleLogin:
            return AuthAPI.appleLogin.authAPIDesc
            
        case .kakaoLogin:
            return AuthAPI.kakaoLoginCallback.authAPIDesc
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .appleLogin:
            return .get
            
        case .kakaoLogin:
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
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default:
            return APIHeader.notAccessTokenHeader
        }
    }
}
