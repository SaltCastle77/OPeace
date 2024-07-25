//
//  BaseAPI.swift
//  API
//
//  Created by 서원지 on 7/18/24.
//

import Foundation

public enum BaseAPI: String {
    case base
    
    public var apiDesc: String {
        switch self {
        case .base:
            return "http://43.203.233.63:8000"
        }
    }
}


