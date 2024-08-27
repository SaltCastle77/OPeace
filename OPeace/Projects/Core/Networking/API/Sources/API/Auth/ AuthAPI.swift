//
//  AuthAPI.swift
//  API
//
//  Created by 서원지 on 7/18/24.
//

import Foundation

public enum AuthAPI {
    case appleLogin
    case kakaoLogin
    case kakaoLoginCallback
    case autoLogin
    case refreshToken
    case fetchUser
    case deleteUser
    case logoutUser
    case userVerify
    case userBlock
    case fetchUserBlock
    case realseBlockUser(userID: String)
    
    
    public var authAPIDesc: String {
        switch self {
        case .appleLogin:
            return "/oauth/apple/login/callback/"
            
        case .kakaoLogin:
            return "/oauth/kakao/login/"
            
        case .kakaoLoginCallback:
            return "/oauth/kakao/login/callback/"
            
        case .autoLogin:
            return "/users/login/"
            
        case .refreshToken:
            return "/users/token/refresh/"
            
        case .fetchUser:
            return "/users/"
            
        case .deleteUser:
            return "/users/"
            
        case .logoutUser:
            return "/users/logout/"
            
        case .userVerify:
            return "/users/verify/"
            
        case .userBlock:
            return "/users/block/"
            
        case .fetchUserBlock:
            return "/users/blocks/"
            
        case .realseBlockUser(let userID):
            return "/users/block/\(userID)/"
        }
    }
}

