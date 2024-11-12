//
//  UserDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public struct UserDTOModel: Codable, Equatable {
  public let data: UserResponseDTOModel
  
  public init(data: UserResponseDTOModel) {
    self.data = data
  }
}

public struct UserResponseDTOModel: Codable, Equatable {
  public let job, generation, nickname, email: String
  public let isFirstLogin: Bool
  public let year: Int
  
  public init(
    job: String,
    generation: String,
    nickname: String,
    email: String,
    isFirstLogin: Bool,
    year: Int
  ) {
    self.job = job
    self.generation = generation
    self.nickname = nickname
    self.email = email
    self.isFirstLogin = isFirstLogin
    self.year = year
  }
}
