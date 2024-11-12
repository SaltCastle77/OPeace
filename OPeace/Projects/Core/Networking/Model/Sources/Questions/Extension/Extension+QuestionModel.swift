//
//  Extension+QuestionModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public extension QuestionModel {
  func toQuestionDTOToModel() -> QuestionDTOModel {
    
    let content: [QuestionContentData] = self.data?.results?.compactMap( { data in
        return QuestionContentData(
          id: data.id ?? .zero,
          error: data.error ?? "",
          userInfo: data.userInfo?.toDTO() ,
          emoji: data.emoji ?? "",
          title: data.title ?? "",
          choiceA: data.choiceA ?? "",
          choiceB: data.choiceB ?? "",
          answerRatio: data.answerRatio?.toDTO(),
          answerCount: data.answerCount ?? .zero,
          likeCount: data.likeCount ?? .zero,
          reportCount: data.reportCount ?? .zero,
          metadata: data.metadata?.toDTO(),
          createdAt: data.createdAt ?? ""
        )
    }) ?? []
    
    let data: QuestionResponseDTOModel = .init(
      error: self.data?.error ?? "" ,
      count: self.data?.count ?? .zero,
      content: content
    )
    return QuestionDTOModel(data: data)
  }
}

extension UserInfo{
  func toDTO() -> UserInfoDTO {
    let data: UserInfoDTO = .init(
      userID: self.userID ?? "",
      userNickname: self.userNickname ?? "",
      userJob: self.userJob ?? "",
      userGeneration: self.userGeneration ?? ""
    )
    
    return data
  }
  
}

extension Metadata {
  func toDTO() -> MetadataDTO {
    let data: MetadataDTO = .init(
      liked: self.liked ?? false,
      voted: self.voted ?? false,
      votedTo: self.votedTo ?? ""
    )
    
    return data
  }
}

extension AnswerRatio {
  func toDTO() -> AnswerRatioDTO {
    let data: AnswerRatioDTO = .init(
      answerRatioA: self.a ?? .zero,
      answerRatioB: self.b ?? .zero
    )
    
    return data
  }
}
