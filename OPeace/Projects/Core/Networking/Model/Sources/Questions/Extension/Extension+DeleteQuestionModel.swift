//
//  Extension+DeleteQuestionModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

public extension DeleteQuestionModel {
  func toFlagQuestionDTOToModel() -> FlagQuestionDTOModel {
    let data: FlagQuestionResponseDTOModel = .init(
      status: self.data?.status ?? false,
      message: self.data?.message ?? ""
    )
    
    return FlagQuestionDTOModel(data: data)
  }
}
