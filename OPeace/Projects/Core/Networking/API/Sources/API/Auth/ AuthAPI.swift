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
    
    
    public var authAPIDesc: String {
        switch self {
        case .appleLogin:
            return "/oauth/apple/login/callback"
            
        case .kakaoLogin:
            return "/oauth/kakao/login/"
            
        case .kakaoLoginCallback:
            return "/oauth/kakao/login/callback/"
        }
    }
}

