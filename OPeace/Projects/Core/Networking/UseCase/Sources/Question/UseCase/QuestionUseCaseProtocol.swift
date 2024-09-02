//
//  QuestionUseCaseProtocol.swift
//  UseCase
//
//  Created by 서원지 on 8/13/24.
//

import Foundation
import Model

public protocol QuestionUseCaseProtocol {
    func fetchQuestionList(
        page: Int,
        pageSize: Int,
        job: String,
        generation: String,
        sortBy: QuestionSort) async throws -> QuestionModel?
    func myQuestionList(page: Int, pageSize: Int)  async throws -> QuestionModel?
    func createQuestion(
        emoji: String,
        title: String,
        choiceA: String,
        choiceB: String
    ) async throws -> CreateQuestionModel?
    func isVoteQuestionLike(questionID: Int) async throws -> VoteQuestionLikeModel?
    func isVoteQuestionAnswer(questionID: Int, choicAnswer: String) async throws -> QuestionVoteModel?
    func deleteQuestion(questionID: Int) async throws -> DeleteQuestionModel?
    func reportQuestion(questionID: Int, reason: String) async throws -> ReportQuestionModel?
    func statusQuestion(questionID: Int) async throws -> StatusQuestionModel?
}
