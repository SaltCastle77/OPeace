//
//  CreateQuestionDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public struct CreateQuestionDTOModel: Codable, Equatable {
  public let data: CreateQuestionResponseDTOModel
  
  public init(data: CreateQuestionResponseDTOModel) {
    self.data = data
  }
}

public struct CreateQuestionResponseDTOModel: Codable, Equatable {
  public let id: Int
  public let userID: String
  public let emoji: String
  public let title, choiceA, choiceB, createAt: String
  
  public init(
    id: Int = .zero,
    userID: String = "",
    emoji: String = "",
    title: String = "",
    choiceA: String = "",
    choiceB: String = "",
    createAt: String = ""
  ) {
    self.id = id
    self.userID = userID
    self.emoji = emoji
    self.title = title
    self.choiceA = choiceA
    self.choiceB = choiceB
    self.createAt = createAt
  }
}

