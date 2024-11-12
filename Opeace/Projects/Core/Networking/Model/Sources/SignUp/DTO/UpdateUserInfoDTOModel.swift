//
//  UpdateUserInfoDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public struct UpdateUserInfoDTOModel: Codable, Equatable {
  public let data: UpdateUserInfoResponseDTOModel
  
  public init(
    data: UpdateUserInfoResponseDTOModel
  ) {
    self.data = data
  }
}

public struct UpdateUserInfoResponseDTOModel: Codable, Equatable {
  public let socialID, socialType, email: String
  public let createdAt, generation: String
  public let year: Int?
  public let job, nickname: String?
  public let isFirstLogin: Bool
  
  public init(
    socialID: String,
    socialType: String,
    email: String,
    createdAt: String,
    nickname: String?,
    year: Int?,
    job: String?,
    generation: String,
    isFirstLogin: Bool
  ) {
    self.socialID = socialID
    self.socialType = socialType
    self.email = email
    self.createdAt = createdAt
    self.nickname = nickname
    self.year = year
    self.job = job
    self.generation = generation
    self.isFirstLogin = isFirstLogin
  }
}
