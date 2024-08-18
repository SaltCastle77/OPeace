//
//  QuestionRepository.swift
//  UseCase
//
//  Created by 서원지 on 8/13/24.
//

import Foundation
import Combine

import Model
import Service
import Utills

import Moya

@Observable
public class QuestionRepository: QuestionRepositoryProtocol {
    private let provider = MoyaProvider<QuestionService>()
    
    public init() {
        
    }
    
    //MARK: - 피드 목록API
    public func fetchQuestionList(page: Int, pageSize: Int) async throws -> QuestionModel? {
        return try await provider.requestAsync(.fetchQuestionList(
            page: page,
            pageSize: pageSize
        ), decodeTo: QuestionModel.self)
    }
    
    //MARK: - 프로필 내가 쓴글 목록 조회 API
    public func myQuestionList(
        page: Int,
        pageSize: Int
    ) async throws -> QuestionModel? {
        return try await provider.requestAsync(.myQuestionList(
            page: page,
            pageSize: pageSize
        ), decodeTo: QuestionModel.self)
    }
    
    //MARK: - 질문 생성API
    public func createQuestion(
        emoji: String,
        title: String,
        choiceA: String,
        choiceB: String
    ) async throws -> CreateQuestionModel? {
        return try await provider.requestAsync(.createQuestion(
            emoji: emoji,
            title: title,
            choiceA: choiceA,
            choiceB: choiceB), decodeTo: CreateQuestionModel.self)
    }
}
