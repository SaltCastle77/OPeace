//
//  UserBlockListDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/10/24.
//

import Foundation

public struct UserBlockListDTOModel: Codable, Equatable {
  public let data: [UserBlockListResponseDTOModel]
  
  public init(
    data: [UserBlockListResponseDTOModel]
  ) {
    self.data = data
  }
}


public struct UserBlockListResponseDTOModel: Codable, Equatable {
  public let blockID: Int
  public let blockedUserID, nickname, job, generation: String
  
  public init(
    blockID: Int,
    blockedUserID: String,
    nickname: String,
    job: String,
    generation: String
  ) {
    self.blockID = blockID
    self.blockedUserID = blockedUserID
    self.nickname = nickname
    self.job = job
    self.generation = generation
  }
}
