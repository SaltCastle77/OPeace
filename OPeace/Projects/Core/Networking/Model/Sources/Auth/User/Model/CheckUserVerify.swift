//
//  CheckUserVerify.swift
//  Model
//
//  Created by 서원지 on 8/6/24.
//
import Foundation

public struct CheckUserVerifyModel: Decodable {
  let detail, code: String?
  let data: CheckUserResponse?
  let message: [Message]?
  
}

// MARK: - DataClass
public struct CheckUserResponse: Decodable {
  let status: Bool?
  let message: String?
  let user: User?
  
}

// MARK: - User
public struct User: Decodable {
  let socialID, socialType, email: String?
  let phone: String?
  let createdAt, lastLogin, nickname: String?
  let year: Int?
  let job, generation: String?
  let isFirstLogin: Bool?
  
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

// MARK: - Message
struct Message: Decodable {
  let tokenClass, tokenType, message: String?
  
  enum CodingKeys: String, CodingKey {
    case tokenClass = "token_class"
    case tokenType = "token_type"
    case message
  }
}

