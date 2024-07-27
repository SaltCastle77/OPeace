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
    case kakaoLogin(code: String, accessToken: String)
}

extension KakaoService: KakaoBaseTargetType {
    public var path: String {
        switch self {
        case .kakaoLogin:
            return AuthAPI.kakaoLoginCallback.authAPIDesc
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
        case .kakaoLogin(let code, let accessToken):
            let parameters: [String: Any] = [
                "code": code,
                "accessToken": accessToken
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .kakaoLogin(_, let accessToken):
            let headers: [String: String] = [
                APIHeader.contentType : APIHeaderManger.shared.contentType,
//                APIHeader.accessToken : "Bearer \(accessToken)",
                "Accept": APIHeaderManger.shared.contentType
            ]
            return headers
        }
    }
}
