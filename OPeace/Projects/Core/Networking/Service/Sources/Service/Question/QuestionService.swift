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
    case fetchQuestionList(page: Int, pageSize: Int, job: String, generation: String, sortBy: String)
    case myQuestionList(page: Int, pageSize: Int)
    case createQuestion(
        emoji: String,
        title: String,
        choiceA: String,
        choiceB: String
    )
    case isVoteQustionLike(id: Int)
    case isVoteQuestionAnswer(id: Int, userChoice: String)
    case deleteQuestion(id: Int)
    
    
}

extension QuestionService: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchQuestionList:
            return QuestionAPI.feedList.questionAPIDesc
            
        case .myQuestionList:
            return QuestionAPI.myWriteQuestionList.questionAPIDesc
            
        case .createQuestion:
            return QuestionAPI.createQuestion.questionAPIDesc
            
        case .isVoteQustionLike(let id):
            return QuestionAPI.questionLikeVote(id: id).questionAPIDesc
            
        case .isVoteQuestionAnswer(let id, _):
            return QuestionAPI.questionAnswerVote(id: id).questionAPIDesc
            
        case .deleteQuestion(let id):
            return QuestionAPI.questionDelete(id: id).questionAPIDesc
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchQuestionList:
            return .get
            
        case .myQuestionList:
            return .get
            
        case .createQuestion:
            return .post
            
        case .isVoteQustionLike:
            return .post
            
        case .isVoteQuestionAnswer:
            return .post
            
        case .deleteQuestion:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchQuestionList(let page, let pageSize, let job, let generation, let sortBy):
            let parameters: [String: Any] = [
                "page": page,
                "page_size": pageSize,
                "job": job,
                "generation": generation,
                "sort_by": sortBy
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .myQuestionList(let page, let pageSize):
            let parameters: [String: Any] = [
                "page": page,
                "page_size": pageSize
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .createQuestion(let emoji, let title,  let choiceA, let choiceB):
            let parameters: [String: Any] = [
                "emoji": emoji,
                "title": title,
                "choice_a": choiceA,
                "choice_b": choiceB
            ]
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .isVoteQustionLike(id: let id):
            let parmeters: [String: Any] = [
                "id": id
            ]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
        case .isVoteQuestionAnswer(let id,  let userChoice):
            let parmeters: [String: Any] = [
                "id": id,
                "user_choice": userChoice
            ]
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default)
            
            
        case .deleteQuestion(let id):
            let parameters: [String: Any] = [
                "id": id
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
