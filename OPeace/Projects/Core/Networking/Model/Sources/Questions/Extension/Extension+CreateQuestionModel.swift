//
//  Extension+CreateQuestionModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public extension CreateQuestionModel {
  func toCreateQuestionDTOToModel() -> CreateQuestionDTOModel {
    let data: CreateQuestionResponseDTOModel = .init(
      id: self.data?.id ?? .zero,
      userID: self.data?.userID ?? "",
      emoji: self.data?.emoji ?? "",
      title: self.data?.title ?? "",
      choiceA: self.data?.choiceA ?? "",
      choiceB: self.data?.choiceB ?? "",
      createAt: self.data?.createAt ?? ""
    )
    
    return CreateQuestionDTOModel(data: data)
  }
}
