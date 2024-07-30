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
    public static let accepot = "accept"
    public static let accessTokenKeyChain = try? Keychain().get("ACCESS_TOKEN") ?? ""
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
    
    public static var baseHeader: Dictionary<String, String> {
        [
          contentType : APIHeaderManger.shared.contentType,
          accessToken : accessTokenKeyChain ?? "",
          accepot: APIHeaderManger.shared.contentType
        ]
    }
    
    public static var notAccessTokenHeader: Dictionary<String, String> {
        [
          contentType : APIHeaderManger.shared.contentType,
//          accessToken : "Bearer \(accessTokenKeyChain ?? "")",
          accepot: APIHeaderManger.shared.contentType
        ]
    }
    
}

