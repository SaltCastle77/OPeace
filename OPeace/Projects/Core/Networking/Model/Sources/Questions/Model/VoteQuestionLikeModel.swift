//
//  VoteQuestionLike.swift
//  Model
//
//  Created by 서원지 on 8/25/24.
//

import Foundation

public struct VoteQuestionLikeModel: Decodable {
     let data: VoteQuestionLikeResponse?
    
}

// MARK: - DataClass
struct VoteQuestionLikeResponse: Decodable{
     let question: Int?
     let userID, createAt: String?

     enum CodingKeys: String, CodingKey {
        case question
        case userID = "user_id"
        case createAt = "create_at"
    }
}
