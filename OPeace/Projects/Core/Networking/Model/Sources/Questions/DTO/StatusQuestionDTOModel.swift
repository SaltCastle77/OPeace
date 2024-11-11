//
//  StatusQuestionDTOModel.swift
//  Model
//
//  Created by Wonji Suh  on 11/11/24.
//

import Foundation

public struct StatusQuestionDTOModel: Codable, Equatable {
  public let data: StatusQuestionResponseDTOModel
  
  public init(
    data: StatusQuestionResponseDTOModel
  ) {
    self.data = data
  }
}

public struct StatusQuestionResponseDTOModel: Codable, Equatable {
  public let error: String
  public let id: Int
  public let status: StatusDTO?
  public let overallRatioA,  overallRatioB: Double
  
  public init(
    error: String,
    id: Int,
    status: StatusDTO?,
    overallRatioA: Double,
    overallRatioB: Double
  ) {
    self.error = error
    self.id = id
    self.status = status
    self.overallRatioA = overallRatioA
    self.overallRatioB = overallRatioB
  }
}


public struct StatusDTO: Codable, Equatable {
  public let statusA, statusB: [String: Double]?
  
  public init(statusA: [String : Double], statusB: [String : Double]?) {
    self.statusA = statusA
    self.statusB = statusB
  }
}
