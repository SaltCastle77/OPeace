//
//  BaseAPI.swift
//  API
//
//  Created by 서원지 on 7/18/24.
//

import Foundation

public enum BaseAPI: String {
    case base
    case appleLoginURL
    
    public var apiDesc: String {
        switch self {
        case .base:
            return "https://opeace.site"
            
        case .appleLoginURL:
            return "https://appleid.apple.com"
        }
    }
}


