//
//  RefreshModel.swift
//  Model
//
//  Created by 서원지 on 8/1/24.
//

// MARK: - Welcome
public struct RefreshModel: Codable, Equatable {
    public let data: RefreshModelResponse?
    
    public init(
        data: RefreshModelResponse?
    ) {
        self.data = data
    }
}

// MARK: - DataClass
public struct RefreshModelResponse: Codable, Equatable {
    public let accessToken, refreshToken: String?

    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
    
    public init(
        accessToken: String?,
        refreshToken: String?
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
