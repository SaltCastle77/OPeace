//
//  AgreeMentAPI.swift
//  API
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

public enum AgreeMentAPI: String {
    case seriveTerms
    case privacyPolicy
    
    public var agreeMentDesc: String {
        switch self {
        case .seriveTerms:
            return "https://material-wok-80b.notion.site/OPEACE-033fd56255c44d3780bf15d35806d57e?pvs=4"
        case .privacyPolicy:
            return "https://material-wok-80b.notion.site/OPEACE-1dd9453836af450fa7750e1fca2a2531?pvs=4"
        }
    }
}
