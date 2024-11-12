//
//  QuestionDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public struct QuestionDTOModel: Codable, Equatable {
  public var data: QuestionResponseDTOModel?
  
  public init(
    data: QuestionResponseDTOModel?
  ) {
    self.data = data
  }
}

public struct QuestionResponseDTOModel: Codable, Equatable {
  public let error: String
  public let count: Int
  public var content: [QuestionContentData]?
  
  public init(
    error: String,
    count: Int,
    content: [QuestionContentData]? = nil
  ) {
    self.error = error
    self.count = count
    self.content = content
  }
    
}

public struct QuestionContentData: Equatable, Codable {
  public let id: Int
  public let error: String
  public let userInfo: UserInfoDTO?
  public let emoji, title: String?
  public let choiceA, choiceB: String
  public let answerRatio: AnswerRatioDTO?
  public let answerCount: Int
  public let likeCount, reportCount: Int
  public let metadata: MetadataDTO?
  public let createdAt: String
  
  public init(
    id: Int,
    error: String,
    userInfo: UserInfoDTO?,
    emoji: String?,
    title: String?,
    choiceA: String,
    choiceB: String,
    answerRatio: AnswerRatioDTO?,
    answerCount: Int,
    likeCount: Int,
    reportCount: Int,
    metadata: MetadataDTO?,
    createdAt: String
  ) {
    self.id = id
    self.error = error
    self.userInfo = userInfo
    self.emoji = emoji
    self.title = title
    self.choiceA = choiceA
    self.choiceB = choiceB
    self.answerRatio = answerRatio
    self.answerCount = answerCount
    self.likeCount = likeCount
    self.reportCount = reportCount
    self.metadata = metadata
    self.createdAt = createdAt
  }
}

public struct  AnswerRatioDTO: Codable, Equatable {
  public let answerRatioA, answerRatioB: Double
  
  public init(
    answerRatioA: Double,
    answerRatioB: Double
  ) {
    self.answerRatioA = answerRatioA
    self.answerRatioB = answerRatioB
  }
}

public struct MetadataDTO: Codable, Equatable {
  public let liked, voted: Bool
  public let votedTo: String
  
  public init(
    liked: Bool,
    voted: Bool,
    votedTo: String
  ) {
    self.liked = liked
    self.voted = voted
    self.votedTo = votedTo
  }
}


public struct UserInfoDTO: Codable, Equatable {
  public let userID, userNickname, userJob, userGeneration: String
  
  public init(
    userID: String,
    userNickname: String,
    userJob: String,
    userGeneration: String
  ) {
    self.userID = userID
    self.userNickname = userNickname
    self.userJob = userJob
    self.userGeneration = userGeneration
  }
}
