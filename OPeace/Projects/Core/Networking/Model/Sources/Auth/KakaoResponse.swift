//
//  KakaoResponse.swift
//  Model
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

// MARK: - Welcome
public struct KakaoResponseModel: Codable, Equatable {
    public let data: KakaoResponse?
    
    public init(data: KakaoResponse?) {
        self.data = data
    }
}

public struct KakaoResponse: Codable, Equatable {
    public let socialID: String?
    public let accessToken: String?
    public let refreshToken: String?

    public enum CodingKeys: String, CodingKey {
        case socialID = "social_id"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
    
    public init(socialID: String?, accessToken: String?, refreshToken: String?) {
        self.socialID = socialID
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
