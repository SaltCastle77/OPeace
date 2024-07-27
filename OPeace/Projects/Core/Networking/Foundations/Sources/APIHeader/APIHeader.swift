//
//  APIHeader.swift
//  Foundations
//
//  Created by 서원지 on 7/18/24.
//

import Foundation
import KeychainAccess

public struct APIHeader{
    
    public static let contentType = "Content-Type"
    public static let accessToken = "Authorization"
    
    public init() {}
    
}

extension APIHeader {
    static func baseHeaders(_ headers: [String: String]?) -> [String: String] {
        var baseHeaders = baseHeader
        if let headers = headers {
            baseHeaders.merge(headers) { $1 }
        }
        return baseHeaders
    }
    
    static var baseHeader: Dictionary<String, String> {
        [
          contentType : APIHeaderManger.shared.contentType
        ]
    }
    
    static var kakakoHeader: Dictionary<String, String> {
        let kakaoKeyChain = try? Keychain().get("KAKAKO_ID_TOKEN")
        return   [
            contentType : APIHeaderManger.shared.contentType,
//            accessToken : "Bearer \(kakaoKeyChain)",
            "accept": APIHeaderManger.shared.contentType
            ]
            
    }
}

