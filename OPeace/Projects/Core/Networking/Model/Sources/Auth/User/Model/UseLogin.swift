//
//  UseLogin.swift
//  Model
//
//  Created by 서원지 on 8/4/24.
//

import Foundation

public struct UseLoginModel: Decodable {
  let data: UseLoginResponse?
  
}

// MARK: - DataClass
struct UseLoginResponse: Decodable {
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
