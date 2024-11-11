//
//  Extension+StatusQuestionModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public extension StatusQuestionModel {
  func toStatusDTOToModel() -> StatusQuestionDTOModel {
    let error = self.data?.error ?? ""
    let id = self.data?.id ?? .zero
    let status = self.data?.stats?.toDTO()
    let overallRatioA = self.data?.overallRatio?.a ?? .zero
    let overallRatioB = self.data?.overallRatio?.b ?? .zero
    
    let data = StatusQuestionResponseDTOModel(
      error: error,
      id: id,
      status: status,
      overallRatioA: overallRatioA,
      overallRatioB: overallRatioB
    )
    
    return StatusQuestionDTOModel(data: data)
  }
}

extension Stats {
  func toDTO() -> StatusDTO {
    return StatusDTO(statusA: self.a ?? [:], statusB: self.b ?? [:])
  }
}

