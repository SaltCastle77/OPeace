//
//  QuestionUseCase.swift
//  UseCase
//
//  Created by 서원지 on 8/13/24.
//

import Foundation

import Model
import DiContainer

import ComposableArchitecture

public struct QuestionUseCase: QuestionUseCaseProtocol {
    private let repository: QuestionRepositoryProtocol
    
    public init(
        repository: QuestionRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    //MARK: - 피드 목록 조회
    public func fetchQuestionList(
        page: Int,
        pageSize: Int
    ) async throws -> QuestionModel? {
        try await repository.fetchQuestionList(page: page, pageSize: pageSize)
    }
    
    //MARK: - 질문 생성
    public func createQuestion(
        emoji: String,
        title: String,
        choiceA: String,
        choiceB: String
    ) async throws -> CreateQuestionModel? {
        try await repository.createQuestion(
            emoji: emoji,
            title: title,
            choiceA: choiceA,
            choiceB: choiceB
        )
    }
}

extension QuestionUseCase : DependencyKey {
    public static let liveValue: QuestionUseCase  = {
        let questionRepository: QuestionRepositoryProtocol = DependencyContainer.live.resolve(QuestionRepositoryProtocol.self) ?? DefaultQuestionRepository()
        return QuestionUseCase(repository: questionRepository)
    }()
}

public extension DependencyValues {
    var questionUseCase: QuestionUseCaseProtocol {
        get { self[QuestionUseCase.self] }
        set { self[QuestionUseCase.self] = newValue  as! QuestionUseCase }
    }
}
