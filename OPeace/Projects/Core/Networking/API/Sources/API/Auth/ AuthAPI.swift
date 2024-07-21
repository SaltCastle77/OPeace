//
//  AuthAPI.swift
//  API
//
//  Created by 서원지 on 7/18/24.
//

import Foundation

public enum AuthAPI : String {
    case updateAppleRefreshToken
    case tryRevoke
    case insertAppleRefreshToken
    case authRefresh
    case authAccess
    case tryLogin
    
    public var apiDesc: String {
        switch self {
        case .updateAppleRefreshToken:
            return "updateAppleRefreshToken"
        case .tryRevoke:
            return "tryRevoke"
        case .insertAppleRefreshToken:
            return "insertAppleRefreshToken"
        case .authRefresh:
            return "auth/refresh"
        case .authAccess:
            return "auth/access"
        case .tryLogin:
            return "tryLogin"
        }
    }
}
