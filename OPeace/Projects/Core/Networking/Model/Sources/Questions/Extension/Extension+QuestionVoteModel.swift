//
//  Extension+QuestionVoteModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//
//let question: Int?
//let userID, createAt: String?
import Foundation

public extension QuestionVoteModel {
  func toFlagQuestionDTOToModel() -> FlagQuestionDTOModel {
    let data: FlagQuestionResponseDTOModel = .init(
      id: self.data?.id ?? .zero,
      question: self.data?.question ?? .zero,
      userID: self.data?.userID ?? "",
      userChoice: self.data?.userChoice ?? ""
    )
    return FlagQuestionDTOModel(data: data)
  }
}
