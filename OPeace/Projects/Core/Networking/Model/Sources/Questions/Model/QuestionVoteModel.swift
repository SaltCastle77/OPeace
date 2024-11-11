//
//  QuestionVoteModel.swift
//  Model
//
//  Created by 서원지 on 8/26/24.
//

import Foundation
// MARK: - Welcome
public struct QuestionVoteModel: Codable, Equatable {
    public let data: QuestionVoteResponseModel?
    
    public init(data: QuestionVoteResponseModel?
    ) {
        self.data = data
    }
}

// MARK: - DataClass
public struct QuestionVoteResponseModel: Codable, Equatable {
    public let id, question: Int?
    public let userID, userChoice: String?

    public enum CodingKeys: String, CodingKey {
        case id, question
        case userID = "user_id"
        case userChoice = "user_choice"
    }
    
    public init(
        id: Int?,
        question: Int?,
        userID: String?,
        userChoice: String?
    ) {
        self.id = id
        self.question = question
        self.userID = userID
        self.userChoice = userChoice
    }
}

