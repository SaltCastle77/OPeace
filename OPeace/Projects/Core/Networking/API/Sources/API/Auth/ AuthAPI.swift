//
//  AuthAPI.swift
//  API
//
//  Created by 서원지 on 7/18/24.
//

import Foundation

public enum AuthAPI : String {
    case appleLogin
    case kakaoLogin
    case kakaoLoginCallback
    case autoLogin
    case refreshToken
    case fetchUser
    case deleteUser
    
    
    public var authAPIDesc: String {
        switch self {
        case .appleLogin:
            return "/oauth/apple/login/callback"
            
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
        }
    }
}

