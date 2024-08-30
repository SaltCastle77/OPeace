//
//  UpdateUserInfoModel.swift
//  Model
//
//  Created by 서원지 on 7/30/24.
//

import Foundation

// MARK: - Welcome
public struct UpdateUserInfoModel: Codable, Equatable {
    public var data: UpdateUserInfoResponse?
    
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

public extension UpdateUserInfoModel {
    static var mockModel: UpdateUserInfoModel = UpdateUserInfoModel(
        data: UpdateUserInfoResponse(
            socialID: "apple_001096.cf7680b2761f4de694a1d1c21ea507a6.1112",
            socialType: "apple",
            email: "shuwj81@daum.net",
            phone: nil,
            createdAt: "2024-08-29 01:39:57",
            lastLogin: "2024-08-30 18:25:17",
            nickname: "오피스",
            year: 1998,
            job: "개발",
            generation: "Z 세대",
            isFirstLogin: true
        )
    )
}
