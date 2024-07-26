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
import Utills

public enum KakaoService {
    case kakaoLogin(accessToken: String)
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
    
    public var headers: [String : String]? {
        switch self {
        case .kakaoLogin(let accessToken):
            let headers: [String: String] = [
                
                APIHeader.contentType : APIHeaderManger.shared.contentType,
//                APIHeader.accessToken : "Bearer \(accessToken)",
                "accept": APIHeaderManger.shared.contentType
            ]
            
            return headers
        }
    }
}
