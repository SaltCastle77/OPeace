//
//  DefaultQuestionRepository.swift
//  UseCase
//
//  Created by 서원지 on 8/13/24.
//

import Foundation
import Model

public final class DefaultQuestionRepository: QuestionRepositoryProtocol {
    
    public init() {
        
    }
    
    public func fetchQuestionList(
        page: Int,
        pageSize: Int,
        job: String,
        generation: String,
        sortBy: QuestionSort) async throws -> QuestionModel? {
            return nil
    }
    
    public func myQuestionList(
        page: Int,
        pageSize: Int
    ) async throws -> QuestionModel? {
        return nil
    }
    
    public func createQuestion(
        emoji: String,
        title: String,
        choiceA: String,
        choiceB: String
    ) async throws -> CreateQuestionModel? {
        return nil
    }
    
    public func isVoteQuestionLike(questionID: Int) async throws -> VoteQuestionLikeModel? {
        return nil
    }
    
    public func isVoteQuestionAnswer(
        questionID: Int,
        choicAnswer: String
    ) async throws -> QuestionVoteModel? {
        return nil
    }
    
    public func deleteQuestion(questionID: Int) async throws -> DeleteQuestionModel? {
        return nil
    }
    
    public func reportQuestion(
        questionID: Int,
        reason: String
    ) async throws -> ReportQuestionModel? {
        return nil
    }
    
    public func statusQuestion(
        questionID: Int
    ) async throws -> StatusQuestionModel? {
        return nil
    }
}
