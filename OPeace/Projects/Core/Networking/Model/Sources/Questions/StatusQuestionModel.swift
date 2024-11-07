//
//  StatusQuestionModel.swift
//  Model
//
//  Created by 서원지 on 8/31/24.
//

import Foundation

// MARK: - Welcome
public struct StatusQuestionModel: Codable, Equatable {
  public let data: QuestionStatusResponseModel?
  
  public init(
    data: QuestionStatusResponseModel?
  ) {
    self.data = data
  }
}

// MARK: - DataClass
public struct QuestionStatusResponseModel: Codable, Equatable {
  public let error: String?
  public  let id: Int?
  public let stats: Stats?
  public let overallRatio: OverallRatio?
  
  public enum CodingKeys: String, CodingKey {
    case id, stats
    case overallRatio = "overall_ratio"
    case error
  }
  
  public init(
    id: Int?,
    stats: Stats?,
    overallRatio: OverallRatio?,
    error: String?
  ) {
    self.id = id
    self.stats = stats
    self.overallRatio = overallRatio
    self.error = error
  }
}

// MARK: - OverallRatio
public struct OverallRatio: Codable, Equatable {
  public let a, b: Double?
  
  public init(
    a: Double?,
    b: Double?
  ) {
    self.a = a
    self.b = b
  }
}

// MARK: - Stats
public struct Stats: Codable, Equatable {
  public let a, b: [String: Double]?
  
  public init(
    a: [String : Double]?,
    b: [String : Double]?
  ) {
    self.a = a
    self.b = b
  }
}
