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
    case fectchUserBlock
    case realseUserBlock(userID: String)
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
            
        case .fectchUserBlock:
            return AuthAPI.fetchUserBlock.authAPIDesc
            
        case .realseUserBlock(let userID):
            return AuthAPI.realseBlockUser(userID: userID).authAPIDesc
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
            
        case .fectchUserBlock:
            return .get
        
        case .realseUserBlock:
            return .delete
        }
    }
    
    public var validationType: ValidationType {
        switch self {
        case .fetchUserInfo:
            return .successCodes
        case .autoLogin:
            return .none
        case .deleteUser:
            return .successCodes
        case .userVerify:
            return .successCodes
        case .userBlock:
            return .successCodes
        case .fectchUserBlock:
            return .successCodes
        case .realseUserBlock:
            return .successCodes
        default:
            return .none
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .appleLogin(let accessToken):
            let parameters: [String: Any] = [
                "access_token": accessToken
            ]
            return parameters
            
        case .kakaoLogin(let accessToken):
            let parameters: [String: Any] = [
                "access_token": accessToken
            ]
            return parameters
        case .refreshToken(let refreshToken):
            let parameters: [String: Any] = [
                "refresh_token": refreshToken
            ]
            return parameters
            
        case .fetchUserInfo:
            return .none
        case .logoutUser(let refreshToken):
            let parameters: [String: Any] = [
                "refresh_token" : refreshToken
                ]
            return parameters
        case .autoLogin:
            let parameters: [String: Any] = [:]
            return parameters
            
        case .deleteUser(let reason):
            let parameters: [String: Any] = [
                "reason" : reason
            ]
            return parameters
            
        case .userVerify:
            let parameters: [String: Any] = [ : ]
            return parameters
            
        case .userBlock(let questioniD, let userID):
            let parameters: [String: Any] = [
                "question_id" : questioniD,
                "blocked_user_id" : userID
            ]
            return parameters
            
        case .fectchUserBlock:
            return .none
        case .realseUserBlock(let userID):
            let parameters: [String: Any] = [
                "blocked_user_id" : userID
            ]
            return parameters
        }
    }
    
    public var shouldUseJSONEncodingForGet: Bool {
            switch self {
            case .userBlock, .deleteUser, .refreshToken, .logoutUser, .realseUserBlock, .logoutUser:
                return true
            default:
                return false
            }
        }

    public var shouldUseQueryStringEncodingForGet: Bool {
            switch self {
            case .appleLogin, .kakaoLogin, .autoLogin, .userVerify:
                return true
            default:
                return false
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
