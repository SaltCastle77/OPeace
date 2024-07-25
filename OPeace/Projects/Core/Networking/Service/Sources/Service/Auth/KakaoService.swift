//
//  KakaoService.swift
//  Service
//
//  Created by 서원지 on 7/24/24.
//

import Foundation
import Moya
import API
import Foundations

public enum KakaoService {
    case kakaoLogin
}


extension KakaoService: KakaoBaseTargetType {
    public var path: String {
        switch self {
        case .kakaoLogin:
            return AuthAPI.kakaoLogin.authAPIDesc
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .kakaoLogin:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .kakaoLogin:
            return .requestPlain
            
        }
    }
}
