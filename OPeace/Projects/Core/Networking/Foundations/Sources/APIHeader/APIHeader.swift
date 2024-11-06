//
//  APIHeader.swift
//  Foundations
//
//  Created by 서원지 on 7/18/24.
//

import Foundation


public struct APIHeader {
    
    public static let contentType = "Content-Type"
    public static let accessToken = "Authorization"
    public static let accept = "accept"

    public init() {}

    public static var accessTokenKeyChain: String {
        return UserDefaults.standard.string(forKey: "ACCESS_TOKEN") ?? ""
    }
    
    public static var accessTokenKey: String {
        get { accessTokenKeyChain }
        set { UserDefaults.standard.set(newValue, forKey: "ACCESS_TOKEN") }
    }
    
    public static var refreshTokenKeyChain: String {
        return UserDefaults.standard.string(forKey: "REFRESH_TOKEN") ?? ""
    }
    
    public static var refreshTokenKey: String {
        get { refreshTokenKeyChain }
        set { UserDefaults.standard.set(newValue, forKey: "REFRESH_TOKEN") }
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
            accept: APIHeaderManger.shared.contentType
        ]
    }
    
    public static var appleLoginHeader: [String: String] {
        [
            contentType : APIHeaderManger.shared.contentAppleType,
            accept: APIHeaderManger.shared.contentType
        ]
    }
}
