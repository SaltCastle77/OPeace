//
//  FlagQuestionDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public struct FlagQuestionDTOModel: Codable, Equatable {
  public let data: FlagQuestionResponseDTOModel
  
  public init(data: FlagQuestionResponseDTOModel) {
    self.data = data
  }
}

public struct FlagQuestionResponseDTOModel: Codable, Equatable {
  public let id, question: Int
  public let userID, reason, createAt, userChoice: String
  public let status: Bool
  public let message: String
  
  public init(
    id: Int = .zero,
    question: Int = .zero,
    userID: String = "",
    reason: String = "",
    createAt: String = "",
    userChoice: String = "",
    status: Bool = false,
    message: String = ""
  ) {
    self.id = id
    self.question = question
    self.userID = userID
    self.reason = reason
    self.createAt = createAt
    self.userChoice = userChoice
    self.status = status
    self.message = message
  }
}
