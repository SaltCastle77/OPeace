//
//  QuestionModel.swift
//  Model
//
//  Created by 서원지 on 8/13/24.
//


import Foundation


public struct QuestionModel: Codable, Equatable {
    public var data: QuestionResponseModel?
    
    public init(data: QuestionResponseModel?) {
        self.data = data
    }
}

// MARK: - DataClass
public struct QuestionResponseModel: Codable, Equatable {
    public let count: Int?
    public let next, previous: String?
    public let results: [ResultData]?
    
    public init(
        count: Int?,
        next: String?,
        previous: String?,
        results: [ResultData]?
    ) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
    
    public enum CodingKeys: String, CodingKey {
        case count, next, previous
        case results = "results"
    }
    
}

// MARK: - Result
public struct ResultData: Codable, Equatable {
    public let id: Int?
    public let userInfo: UserInfo?
    public let emoji, title, choiceA, choiceB: String?
    public let answerCount: Int?
    public let answerRatio: AnswerRatio?
    public let likeCount, reportCount: Int?
    public let metadata: Metadata?
    public let createAt: String?

    public enum CodingKeys: String, CodingKey {
        case id
        case userInfo = "user_info"
        case emoji, title
        case choiceA = "choice_a"
        case choiceB = "choice_b"
        case answerCount = "answer_count"
        case answerRatio = "answer_ratio"
        case likeCount = "like_count"
        case reportCount = "report_count"
        case metadata
        case createAt = "create_at"
    }
}

// MARK: - AnswerRatio
public struct AnswerRatio: Codable, Equatable {
    public let a, b: Double?

    public enum CodingKeys: String, CodingKey {
        case a = "A"
        case b = "B"
    }
    
    public init(
        a: Double?,
        b: Double?
    ) {
        self.a = a
        self.b = b
    }
}

// MARK: - Metadata
public struct Metadata: Codable, Equatable {
   public let liked, voted: Bool?
    public let votedTo: String?

    public enum CodingKeys: String, CodingKey {
        case liked, voted
        case votedTo = "voted_to"
    }
    
    public init(
        liked: Bool?,
        voted: Bool?,
        votedTo: String?
    ) {
        self.liked = liked
        self.voted = voted
        self.votedTo = votedTo
    }
}

// MARK: - UserInfo
public struct UserInfo: Codable, Equatable {
    public let userID, userNickname, userJob, userGeneration: String?

    public enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userNickname = "user_nickname"
        case userJob = "user_job"
        case userGeneration = "user_generation"
    }
    
    public init(
        userID: String?,
        userNickname: String?,
        userJob: String?,
        userGeneration: String?
    ) {
        self.userID = userID
        self.userNickname = userNickname
        self.userJob = userJob
        self.userGeneration = userGeneration
    }
}
