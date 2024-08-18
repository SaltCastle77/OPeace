//
//  QuestionUseCaseProtocol.swift
//  UseCase
//
//  Created by 서원지 on 8/13/24.
//

import Foundation
import Model

public protocol QuestionUseCaseProtocol {
    func fetchQuestionList(page: Int, pageSize: Int) async throws -> QuestionModel?
    func myQuestionList(page: Int, pageSize: Int)  async throws -> QuestionModel?
    func createQuestion(
        emoji: String,
        title: String,
        choiceA: String,
        choiceB: String
    ) async throws -> CreateQuestionModel?
}
