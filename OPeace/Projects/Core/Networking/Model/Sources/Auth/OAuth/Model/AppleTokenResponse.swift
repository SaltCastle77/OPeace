//
//  AppleTokenResponse.swift
//  Model
//
//  Created by 서원지 on 9/14/24.
//

import Foundation

public struct AppleTokenResponse: Codable, Equatable {
    public var access_token: String?
    public var token_type: String?
    public var expires_in: Int?
    public var refresh_token: String?
    public var id_token: String?
    
    public init(
        access_token: String? = nil,
        token_type: String? = nil,
        expires_in: Int? = nil,
        refresh_token: String? = nil,
        id_token: String? = nil) {
        self.access_token = access_token
        self.token_type = token_type
        self.expires_in = expires_in
        self.refresh_token = refresh_token
        self.id_token = id_token
    }
}
