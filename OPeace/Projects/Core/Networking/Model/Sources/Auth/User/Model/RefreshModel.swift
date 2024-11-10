//
//  RefreshModel.swift
//  Model
//
//  Created by 서원지 on 8/1/24.
//

// MARK: - Welcome
public struct RefreshModel: Decodable {
     let data: RefreshModelResponse?
    
}

// MARK: - DataClass
struct RefreshModelResponse: Decodable {
     let accessToken, refreshToken: String?

     enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
