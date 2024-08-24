//
//  CheckUserVerify.swift
//  Model
//
//  Created by 서원지 on 8/6/24.
//
import Foundation

public struct CheckUserVerifyModel: Codable, Equatable {
    public let detail, code: String?
    public let data: CheckUserResponse?
    public let message: [Message]?
    
    public init(
        data: CheckUserResponse?,
        detail: String?,
        code: String?,
        message: [Message]?
    ) {
        self.data = data
        self.detail = detail
        self.code = code
        self.message = message
    }
}

// MARK: - DataClass
public struct CheckUserResponse: Codable, Equatable {
    public let status: Bool?
    public let message: String?
    public let user: User?
    
    public init(
        status: Bool?,
        message: String?,
        user: User?
    ) {
        self.status = status
        self.message = message
        self.user = user
    }
}

// MARK: - User
public struct User: Codable, Equatable {
    public let socialID, socialType, email: String?
    public let phone: String?
    public let createdAt, lastLogin, nickname: String?
    public let year: Int?
    public let job, generation: String?
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
        email: String?,
        phone: String?,
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

// MARK: - Message
public struct Message: Codable, Equatable {
    public let tokenClass, tokenType, message: String?

    public enum CodingKeys: String, CodingKey {
        case tokenClass = "token_class"
        case tokenType = "token_type"
        case message
    }
    
    public init(
        tokenClass: String?,
        tokenType: String?,
        message: String?
    ) {
        self.tokenClass = tokenClass
        self.tokenType = tokenType
        self.message = message
    }
}

