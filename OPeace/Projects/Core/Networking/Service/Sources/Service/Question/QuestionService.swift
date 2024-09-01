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
    case reportQuestion(id: Int, reason: String)
    
    
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
            
        case .reportQuestion(let id, _):
            return QuestionAPI.quetionReport(id: id).questionAPIDesc
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
            
        case .reportQuestion:
            return .post
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .fetchQuestionList(let page, let pageSize, let job, let generation, let sortBy):
            let parameters: [String: Any] = [
                "page": page,
                "page_size": pageSize,
                "job": job,
                "generation": generation,
                "sort_by": sortBy
            ]
            return parameters
        case .myQuestionList(let page, let pageSize):
            let parameters: [String: Any] = [
                "page": page,
                "page_size": pageSize
            ]
            return parameters
        case .createQuestion(let emoji, let title, let choiceA, let choiceB):
            let parameters: [String: Any] = [
                "emoji": emoji,
                "title": title,
                "choice_a": choiceA,
                "choice_b": choiceB
            ]
            return parameters
        case .isVoteQustionLike(let id):
            let parameters: [String: Any] = [
                "id": id
                ]
            return parameters
        case .isVoteQuestionAnswer(let id, let userChoice):
            let parmeters: [String: Any] = [
                "id": id,
                "user_choice": userChoice
            ]
            return parmeters
        case .deleteQuestion(let id):
            let parameters: [String: Any] = [
                "id": id
                ]
            return parameters
        case .reportQuestion(let id, let reason):
            let parameters: [String: Any] = [
                "id": id,
                "reason": reason
                ]
            return parameters
        }
    }
    
    public var shouldUseJSONEncodingForGet: Bool {
            switch self {
            case .isVoteQustionLike, .isVoteQuestionAnswer, .deleteQuestion, .reportQuestion, .createQuestion:
                return true
            default:
                return false
            }
        }

    public var shouldUseQueryStringEncodingForGet: Bool {
            switch self {
            case .fetchQuestionList, .myQuestionList:
                return true 
            default:
                return false
            }
        }
    
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var headers: [String : String]? {
        switch self {      
        default:
            return APIHeader.baseHeader
        }
    }
}
