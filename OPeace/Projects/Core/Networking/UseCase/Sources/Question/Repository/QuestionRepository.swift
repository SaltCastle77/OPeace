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
import AsyncMoya

import Moya

@Observable
public class QuestionRepository: QuestionRepositoryProtocol {
    private let provider = MoyaProvider<QuestionService>(session: Session(interceptor: AuthInterceptor.shared), plugins: [MoyaLoggingPlugin()])
    
    public init() {
        
    }
    
    //MARK: - 피드 목록API
    public func fetchQuestionList(
        page: Int,
        pageSize: Int,
        job: String,
        generation: String,
        sortBy: QuestionSort
    ) async throws -> QuestionModel? {
        return try await provider.requestAsync(.fetchQuestionList(
            page: page,
            pageSize: pageSize,
            job: job,
            generation: generation,
            sortBy: sortBy.questionSortDesc), decodeTo: QuestionModel.self)
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
    
    //MARK: - 좋아요 API
    public func isVoteQuestionLike(questionID: Int) async throws -> VoteQuestionLikeModel? {
        return try await provider.requestAsync(.isVoteQustionLike(
            id: questionID), decodeTo: VoteQuestionLikeModel.self)
    }
    
    //MARK: - 유저 투표 API
    public func isVoteQuestionAnswer(
        questionID: Int,
        choicAnswer: String
    ) async throws -> QuestionVoteModel? {
        return try await provider.requestAsync(.isVoteQuestionAnswer(
            id: questionID,
            userChoice: choicAnswer), decodeTo: QuestionVoteModel.self)
    }
    
    //MARK: - 질문 삭제 API
    public func deleteQuestion(questionID: Int) async throws -> DeleteQuestionModel? {
        return try await provider.requestAsync(.deleteQuestion(id: questionID), decodeTo: DeleteQuestionModel.self)
    }
    
    //MARK: - 유저 질문 신고 API
    public func reportQuestion(
        questionID: Int,
        reason: String
    ) async throws -> ReportQuestionModel? {
        return try await provider.requestAsync(.reportQuestion(
            id: questionID,
            reason: reason
        ), decodeTo: ReportQuestionModel.self)
    }
    
    //MARK: - 유저 투표 결과 API
    public func statusQuestion(
        questionID: Int
    ) async throws -> StatusQuestionModel? {
        return try await provider.requestAsync(.statusQuestion(
            id: questionID), decodeTo: StatusQuestionModel.self)
    }
}
