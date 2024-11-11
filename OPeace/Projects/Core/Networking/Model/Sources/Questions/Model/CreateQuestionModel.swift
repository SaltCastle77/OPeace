//
//  CreateQuestionModel.swift
//  Model
//
//  Created by 서원지 on 8/15/24.
//

import Foundation

public struct CreateQuestionModel: Decodable {
     let data: CreateQuestionResponse?
    
}

// MARK: - DataClass
struct CreateQuestionResponse: Decodable {
     let id: Int?
     let userID: String?
     let emoji: String?
     let title, choiceA, choiceB, createAt: String?
     let updateAt: String?

     enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case emoji, title
        case choiceA = "choice_a"
        case choiceB = "choice_b"
        case createAt = "create_at"
        case updateAt = "update_at"
    }
}

