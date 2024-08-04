//
//  UseLogin.swift
//  Model
//
//  Created by 서원지 on 8/4/24.
//

import Foundation

public struct UseLoginModel: Equatable, Codable {
    public let data: UseLoginResponse?
    
    public init(
        data: UseLoginResponse?
    ) {
        self.data = data
    }
}


// MARK: - DataClass
public struct UseLoginResponse: Codable, Equatable {
    public  let socialID, socialType, email: String?
    public let phone: String?
    public let createdAt, lastLogin, nickname: String?
    public let year: Int?
    public  let job, generation: String?
    public let isFirstLogin: Bool?

    public enum CodingKeys: String, CodingKey {
        case socialID = "social_id"
        case socialType = "social_type"
        case email, phone
        case createdAt = "created_at"
        case lastLogin = "last_login"
        case nickname, year, job, generation
        case isFirstLogin = "is_first_login"
    }
    
    public init(
        socialID: String?,
        socialType: String?,
        email: String?, phone: String?,
        createdAt: String?,
        lastLogin: String?,
        nickname: String?,
        year: Int?,
        job: String?,
        generation: String?,
        isFirstLogin: Bool?
    ) {
        self.socialID = socialID
        self.socialType = socialType
        self.email = email
        self.phone = phone
        self.createdAt = createdAt
        self.lastLogin = lastLogin
        self.nickname = nickname
        self.year = year
        self.job = job
        self.generation = generation
        self.isFirstLogin = isFirstLogin
    }
}
