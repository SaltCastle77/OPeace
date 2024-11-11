//
//  Extension+ReportQuestionModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public extension ReportQuestionModel {
  func toFlagQuestionDTOToModel() -> FlagQuestionDTOModel {
    let data: FlagQuestionResponseDTOModel = .init(
      id: self.data?.id ?? .zero,
      question: self.data?.question ?? .zero,
      userID: self.data?.userID ?? "",
      reason: self.data?.reason ?? "",
      createAt: self.data?.createAt ?? ""
    )
    
    return FlagQuestionDTOModel(data: data)
  }
}
