//
//  UpdateUserInfoModel.swift
//  Model
//
//  Created by 서원지 on 7/30/24.
//

import Foundation

// MARK: - Welcome
public struct UpdateUserInfoModel: Codable, Equatable {
    public let data: UpdateUserInfoResponse?
    
    public init(data: UpdateUserInfoResponse?) {
        self.data = data
    }
    
}

// MARK: - DataClass
public struct UpdateUserInfoResponse: Codable , Equatable {
    public let socialID, socialType, email: String?
    public let phone: String?
    public let createdAt, lastLogin, nickname: String?
    public let year: Int?
    public let job, generation: String?
    public let isFirstLogin: Bool?

    enum CodingKeys: String, CodingKey {
        case socialID = "social_id"
        case socialType = "social_type"
        case email, phone
        case createdAt = "created_at"
        case lastLogin = "last_login"
        case nickname, year, job, generation
        case isFirstLogin = "is_first_login"
    }
}

