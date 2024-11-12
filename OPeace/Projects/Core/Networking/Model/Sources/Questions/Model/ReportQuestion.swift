//
//  ReportQuestion.swift
//  Model
//
//  Created by 서원지 on 8/26/24.
//

import Foundation
// MARK: - Welcome
public struct ReportQuestionModel: Decodable {
     let data: ReportQuestionResponseModel?
   
}

// MARK: - DataClass
struct ReportQuestionResponseModel: Decodable {
     let id, question: Int?
     let userID, reason, createAt: String?

     enum CodingKeys: String, CodingKey {
        case id, question
        case userID = "user_id"
        case reason
        case createAt = "create_at"
    }
}

