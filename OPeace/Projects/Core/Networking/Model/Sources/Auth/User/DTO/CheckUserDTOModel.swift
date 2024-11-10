//
//  CheckUserDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public struct CheckUserDTOModel: Codable, Equatable {
  public let data: CheckUserDTOResponseModel
  
  public init(data: CheckUserDTOResponseModel) {
    self.data = data
  }
}


public struct CheckUserDTOResponseModel: Codable, Equatable {
  public let job, generation, nickname, email: String
  public let isFirstLogin: Bool
  public let year: Int
  public let status: Bool
  
  public init(
    job: String,
    generation: String,
    nickname: String,
    email: String,
    isFirstLogin: Bool,
    year: Int,
    status: Bool
  ) {
    self.job = job
    self.generation = generation
    self.nickname = nickname
    self.email = email
    self.isFirstLogin = isFirstLogin
    self.year = year
    self.status = status
  }
}
