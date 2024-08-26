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
    case appleLogin(accessToken: String)
    case kakaoLogin(accessToken: String)
    case refreshToken(refreshToken: String)
    case fetchUserInfo
    case logoutUser(refreshToken: String)
    case autoLogin
    case deleteUser(reason: String)
    case userVerify
    case userBlock(questioniD: Int, userID: String)
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
            
        case .userVerify:
            return AuthAPI.userVerify.authAPIDesc
            
        case .userBlock:
            return AuthAPI.userBlock.authAPIDesc
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
            
        case .userVerify:
            return .post
            
        case .userBlock:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .appleLogin(let accessToken):
            let parameters: [String: Any] = [
                "access_token": accessToken
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .kakaoLogin(let accessToken):
            let parameters: [String: Any] = [
                "access_token": accessToken
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .refreshToken(let refreshToken):
            let parameters: [String: Any] = [
                "refresh_token": refreshToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
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
            
        case .deleteUser(let reason):
            let parameters: [String: Any] = [
                "reason" : reason
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .userVerify:
            let parameters: [String: Any] = [ : ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .userBlock(let questioniD, let userID):
            let parameters: [String: Any] = [
                "question_id" : questioniD,
                "blocked_user_id" : userID
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
        
    }
    
    public var headers: [String : String]? {
        switch self {
        case .kakaoLogin:
            return APIHeader.notAccessTokenHeader
            
        case .appleLogin:
            return APIHeader.notAccessTokenHeader
            
            
        default:
            return APIHeader.baseHeader
        }
    }
}
