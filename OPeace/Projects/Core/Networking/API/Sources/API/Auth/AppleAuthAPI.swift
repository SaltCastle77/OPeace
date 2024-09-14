//
//  AppleAuthAPI.swift
//  API
//
//  Created by 서원지 on 9/14/24.
//

import Foundation

public enum AppleAuthAPI {
    case appleToken
    case appleRevokeToken
    
    
    public var appleAuthDesc: String {
        switch self {
        case .appleToken:
            return "auth/token"
        case .appleRevokeToken:
            return "auth/revoke"
        }
    }
}
