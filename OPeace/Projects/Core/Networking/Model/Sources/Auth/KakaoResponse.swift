//
//  KakaoResponse.swift
//  Model
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

// MARK: - Welcome
public struct UserLoginModel: Codable, Equatable {
    public let data: UserLoginResponse?
    
    public init(data: UserLoginResponse?) {
        self.data = data
    }
}

public struct UserLoginResponse: Codable, Equatable {
    public let socialID, accessToken, refreshToken: String?
    public let expiresIn, refreshTokenExpiresIn: Int?
    public let isExpires, isRefreshTokenExpires: Bool?
   

    enum CodingKeys: String, CodingKey {
        case socialID = "social_id"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case refreshTokenExpiresIn = "refresh_token_expires_in"
        case isExpires = "is_expires"
        case isRefreshTokenExpires = "is_refresh_token_expires"
    }
    
    public init(
        socialID: String?,
        accessToken: String?,
        refreshToken: String?,
        expiresIn: Int?,
        refreshTokenExpiresIn: Int?,
        isExpires: Bool?,
        isRefreshTokenExpires: Bool?
    ) {
        self.socialID = socialID
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.refreshTokenExpiresIn = refreshTokenExpiresIn
        self.isExpires = isExpires
        self.isRefreshTokenExpires = isRefreshTokenExpires
    }
}

