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
    pageSize: Int,
    job: String,
    generation: String,
    sortBy: QuestionSort
  ) async throws -> QuestionDTOModel? {
    try await repository.fetchQuestionList(
      page: page,
      pageSize: pageSize,
      job: job,
      generation: generation,
      sortBy: sortBy)
  }
  
  
  //MARK: - 프로필에서 내가 쓴글 조회
  public func myQuestionList(
    page: Int,
    pageSize: Int
  ) async throws -> QuestionDTOModel? {
    try await repository.myQuestionList(page: page, pageSize: pageSize)
  }
  
  //MARK: - 질문 생성
  public func createQuestion(
    emoji: String,
    title: String,
    choiceA: String,
    choiceB: String
  ) async throws -> CreateQuestionDTOModel? {
    try await repository.createQuestion(
      emoji: emoji,
      title: title,
      choiceA: choiceA,
      choiceB: choiceB
    )
  }
  
  //MARK: - 좋아요 누르기
  public func isVoteQuestionLike(questionID: Int) async throws -> FlagQuestionDTOModel? {
    try await repository.isVoteQuestionLike(questionID: questionID)
  }
  
  //MARK: - 응답 선택
  public func isVoteQuestionAnswer(
    questionID: Int,
    choicAnswer: String
  ) async throws -> FlagQuestionDTOModel? {
    try await repository.isVoteQuestionAnswer(questionID: questionID, choicAnswer: choicAnswer)
  }
  
  //MARK: - 내가 쓴글 삭제
  public func deleteQuestion(questionID: Int) async throws -> FlagQuestionDTOModel? {
    try await repository.deleteQuestion(questionID: questionID)
  }
  
  //MARK: - 유저글 신고
  public func reportQuestion(
    questionID: Int,
    reason: String
  ) async throws -> FlagQuestionDTOModel? {
    try await repository.reportQuestion(
      questionID: questionID,
      reason: reason
    )
  }
  
  //MARK: - 투표 결과
  public func statusQuestion(questionID: Int) async throws -> StatusQuestionDTOModel? {
    try await repository.statusQuestion(questionID: questionID)
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
