//
//  Extension+VoteQuestionLikeModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public extension VoteQuestionLikeModel {
  func toFlagQuestionDTOToModel() -> FlagQuestionDTOModel {
    let data: FlagQuestionResponseDTOModel = .init(
      question: self.data?.question ?? .zero,
      userID: self.data?.userID ?? "",
      createAt: self.data?.createAt ?? ""
    )
    
    return FlagQuestionDTOModel(data: data)
  }
}
