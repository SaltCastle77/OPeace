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
}
