//
//  CreateQuestionModel.swift
//  Model
//
//  Created by 서원지 on 8/15/24.
//

import Foundation

public struct CreateQuestionModel: Codable, Equatable {
    public let data: CreateQuestionResponse?
    
    public init(
        data: CreateQuestionResponse?
    ) {
        self.data = data
    }
}

// MARK: - DataClass
public struct CreateQuestionResponse: Codable, Equatable {
    public let id: Int?
    public let userID: String?
    public let emoji: Int?
    public let title, choiceA, choiceB, createAt: String?
    public let updateAt: String?

    public enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case emoji, title
        case choiceA = "choice_a"
        case choiceB = "choice_b"
        case createAt = "create_at"
        case updateAt = "update_at"
    }
    
    public init(
        id: Int?,
        userID: String?,
        emoji: Int?,
        title: String?,
        choiceA: String?,
        choiceB: String?,
        createAt: String?,
        updateAt: String?
    ) {
        self.id = id
        self.userID = userID
        self.emoji = emoji
        self.title = title
        self.choiceA = choiceA
        self.choiceB = choiceB
        self.createAt = createAt
        self.updateAt = updateAt
    }
}

