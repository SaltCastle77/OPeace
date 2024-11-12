//
//  StatusQuestionModel.swift
//  Model
//
//  Created by 서원지 on 8/31/24.
//

import Foundation

// MARK: - Welcome
public struct StatusQuestionModel: Decodable {
   let data: QuestionStatusResponseModel?
  
}

// MARK: - DataClass
struct QuestionStatusResponseModel: Decodable {
   let error: String?
    let id: Int?
   let stats: Stats?
   let overallRatio: OverallRatio?
  
   enum CodingKeys: String, CodingKey {
    case id, stats
    case overallRatio = "overall_ratio"
    case error
  }
  
}

// MARK: - OverallRatio
struct OverallRatio: Decodable {
   let a, b: Double?
  
}

// MARK: - Stats
struct Stats: Decodable {
   let a, b: [String: Double]?
  
}
