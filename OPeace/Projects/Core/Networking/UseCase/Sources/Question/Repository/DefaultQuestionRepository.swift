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
    
    
    public func fetchQuestionList(page: Int, pageSize: Int) async throws -> QuestionModel? {
        return nil
    }
    
}
