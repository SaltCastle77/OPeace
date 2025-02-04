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
    sortBy: QuestionSort) async throws -> QuestionDTOModel? {
      return nil
    }
  
  public func myQuestionList(
    page: Int,
    pageSize: Int
  ) async throws -> QuestionDTOModel? {
    return nil
  }
  
  public func createQuestion(
    emoji: String,
    title: String,
    choiceA: String,
    choiceB: String
  ) async throws -> CreateQuestionDTOModel? {
    return nil
  }
  
  public func isVoteQuestionLike(questionID: Int) async throws -> FlagQuestionDTOModel? {
    return nil
  }
  
  public func isVoteQuestionAnswer(
    questionID: Int,
    choicAnswer: String
  ) async throws -> FlagQuestionDTOModel? {
    return nil
  }
  
  public func deleteQuestion(questionID: Int) async throws -> FlagQuestionDTOModel? {
    return nil
  }
  
  public func reportQuestion(
    questionID: Int,
    reason: String
  ) async throws -> FlagQuestionDTOModel? {
    return nil
  }
  
  public func statusQuestion(
    questionID: Int
  ) async throws -> StatusQuestionDTOModel? {
    return nil
  }
}
