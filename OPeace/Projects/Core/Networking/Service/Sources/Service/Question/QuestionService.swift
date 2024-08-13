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
}

extension QuestionService: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchQuestionList:
            return QuestionAPI.feedList.questionAPIDesc
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchQuestionList:
            return .get
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
        }
    }
    public var headers: [String : String]? {
        switch self {
        case .fetchQuestionList:
            return APIHeader.baseHeader
            
        default:
            return APIHeader.baseHeader
        }
    }
}
