//
//  QuestionAPI.swift
//  API
//
//  Created by 서원지 on 8/13/24.
//

import Foundation

public enum QuestionAPI: String {
    case feedList
    case myWriteQuestionList
    case createQuestion
    
    public var questionAPIDesc: String {
        switch self {
        case .feedList:
            return "/v1/questions/"
            
        case .myWriteQuestionList:
            return "/v1/questions/me/"
            
        case .createQuestion:
            return "/v1/question/"
        }
    }
}
