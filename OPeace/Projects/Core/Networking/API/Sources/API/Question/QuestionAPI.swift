//
//  QuestionAPI.swift
//  API
//
//  Created by 서원지 on 8/13/24.
//

import Foundation

public enum QuestionAPI: String {
    case feedList
    case createQuestion
    
    public var questionAPIDesc: String {
        switch self {
        case .feedList:
            return "/v2/questions/"
            
        case .createQuestion:
            return "/v2/question/"
        }
    }
}
