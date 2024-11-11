//
//  VoteQuestionLike.swift
//  Model
//
//  Created by 서원지 on 8/25/24.
//

import Foundation

public struct VoteQuestionLikeModel: Codable, Equatable {
    public let data: VoteQuestionLikeResponse?
    
    public init(
        data: VoteQuestionLikeResponse?
    ) {
        self.data = data
    }
}

// MARK: - DataClass
public struct VoteQuestionLikeResponse: Codable, Equatable {
    public let question: Int?
    public let userID, createAt: String?

    public enum CodingKeys: String, CodingKey {
        case question
        case userID = "user_id"
        case createAt = "create_at"
    }
    
    public init(
        question: Int?,
        userID: String?,
        createAt: String?
    ) {
        self.question = question
        self.userID = userID
        self.createAt = createAt
    }
}
