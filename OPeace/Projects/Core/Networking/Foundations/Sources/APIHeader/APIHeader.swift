//
//  APIHeader.swift
//  Foundations
//
//  Created by 서원지 on 7/18/24.
//

import Foundation
import KeychainAccess


public struct APIHeader {
    
    public static let contentType = "Content-Type"
    public static let accessToken = "Authorization"
    public static let accept = "accept"

    public init() {}

    public static var accessTokenKeyChain: String {
        return (try? Keychain().get("ACCESS_TOKEN")) ?? ""
    }
}

extension APIHeader {
    static func baseHeaders(_ headers: [String: String]?) -> [String: String] {
        var baseHeaders = baseHeader
        if let headers = headers {
            baseHeaders.merge(headers) { $1 }
        }
        return baseHeaders
    }
    
    public static var baseHeader: [String: String] {
        [
            contentType : APIHeaderManger.shared.contentType,
            accessToken : accessTokenKeyChain,  // 키체인에서 값을 가져옴
            accept : APIHeaderManger.shared.contentType
        ]
    }
    
    public static var notAccessTokenHeader: [String: String] {
        [
            contentType : APIHeaderManger.shared.contentType,
            // accessToken : "Bearer \(accessTokenKeyChain)",  // 여기는 필요에 따라 사용
            accept: APIHeaderManger.shared.contentType
        ]
    }
}
