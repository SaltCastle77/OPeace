//
//  AppleAuthService.swift
//  Service
//
//  Created by 서원지 on 9/14/24.
//

import Moya
import API
import Foundations
import Foundation

public enum AppleAuthService {
    case getRefreshToken(code: String, clientSecret: String)
    case revokeToken(clientSecret: String, token: String)
}

extension AppleAuthService : TargetType {
    public var baseURL: URL {
        return URL(string: BaseAPI.appleLoginURL.apiDesc)!
    }
    
    public var path: String {
        switch self {
        case .getRefreshToken:
            return AppleAuthAPI.appleToken.appleAuthDesc
        case .revokeToken:
            return AppleAuthAPI.appleRevokeToken.appleAuthDesc
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .getRefreshToken(let code, let clientSecret):
            let parameters: [String: Any] = [
                "client_id": "io.Opeace.Opeace",
                "client_secret": clientSecret,
                "code": code,
                "grant_type": "authorization_code"
            ]
            return parameters
        case .revokeToken(let clientSecret, let token):
            let parameters: [String: Any] = [
                "client_id": "io.Opeace.Opeace",
                "client_secret": clientSecret,
                "token": token,
                "token_type_hint": "refresh_token"
            ]
            return parameters
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getRefreshToken:
            return .post
        case .revokeToken:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .revokeToken(let clientSecret, let token):
            let parameters: [String: Any] = [
                "client_id": "io.Opeace.Opeace",
                "client_secret": clientSecret,
                "token": token,
                "token_type_hint": "refresh_token"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
            
        case .getRefreshToken(let code, let clientSecret):
            let parameters: [String: Any] = [
                "client_id": "io.Opeace.Opeace",
                "client_secret": clientSecret,
                "code": code,
                "grant_type": "authorization_code"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
      
    public var headers: [String : String]? {
        switch self {
        case .getRefreshToken:
            return APIHeader.appleLoginHeader
        case .revokeToken:
            return APIHeader.appleLoginHeader
            
        default:
            return APIHeader.baseHeader
        }
    }
}
