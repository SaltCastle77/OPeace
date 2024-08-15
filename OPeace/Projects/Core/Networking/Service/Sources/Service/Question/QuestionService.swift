//
//  QuestionService.swift
//  Service
//
//  Created by 서원지 on 8/13/24.
//

import Foundation

import Moya

import API
import Foundations


public enum QuestionService {
    case fetchQuestionList(page: Int, pageSize: Int)
    case createQuestion(
        emoji: String,
        title: String,
        choiceA: String,
        choiceB: String
    )
    
}

extension QuestionService: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchQuestionList:
            return QuestionAPI.feedList.questionAPIDesc
            
        case .createQuestion:
            return QuestionAPI.createQuestion.questionAPIDesc
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchQuestionList:
            return .get
            
        case .createQuestion:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchQuestionList(let page, let pageSize):
            let parameters: [String: Any] = [
                "page": page,
                "page_size": pageSize
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .createQuestion(let emoji, let title,  let choiceA, let choiceB):
            let parameters: [String: Any] = [
                "emoji": 1,
                "title": title,
                "choice_a": choiceA,
                "choice_b": choiceB
            ]
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        switch self {      
        default:
            return APIHeader.baseHeader
        }
    }
}
