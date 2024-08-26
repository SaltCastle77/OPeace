//
//  QuestionAPI.swift
//  API
//
//  Created by 서원지 on 8/13/24.
//

import Foundation

public enum QuestionAPI {
    case feedList
    case myWriteQuestionList
    case createQuestion
    case questionLikeVote(id: Int)
    case questionAnswerVote(id: Int)
    case questionDelete(id: Int)
    
    public var questionAPIDesc: String {
        switch self {
        case .feedList:
            return "/v1/questions/"
            
        case .myWriteQuestionList:
            return "/v1/questions/me/"
            
        case .createQuestion:
            return "/v1/question/"
            
        case .questionLikeVote(let id):
            return "/v1/questions/\(id)/like/"
            
        case .questionAnswerVote(let id):
            return "v1/questions/\(id)/vote"
            
        case .questionDelete(let id):
            return "/v1/question/\(id)/"
        }
    }
}

