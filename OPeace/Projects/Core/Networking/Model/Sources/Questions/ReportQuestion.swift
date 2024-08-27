//
//  ReportQuestion.swift
//  Model
//
//  Created by 서원지 on 8/26/24.
//

import Foundation
// MARK: - Welcome
public struct ReportQuestionModel: Codable, Equatable {
    public let data: ReportQuestionResponseModel?
    
    public init(
        data: ReportQuestionResponseModel?
    ) {
        self.data = data
    }
}

// MARK: - DataClass
public struct ReportQuestionResponseModel: Codable, Equatable {
    public let id, question: Int?
    public let userID, reason, createAt: String?

    public enum CodingKeys: String, CodingKey {
        case id, question
        case userID = "user_id"
        case reason
        case createAt = "create_at"
    }
    
    public init(
        id: Int?,
        question: Int?,
        userID: String?,
        reason: String?,
        createAt: String?
    ) {
        self.id = id
        self.question = question
        self.userID = userID
        self.reason = reason
        self.createAt = createAt
    }
}

