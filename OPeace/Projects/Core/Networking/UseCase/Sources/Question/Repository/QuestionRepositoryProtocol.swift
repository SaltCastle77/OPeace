//
//  QuestionRepositoryProtocol.swift
//  UseCase
//
//  Created by 서원지 on 8/13/24.
//

import Foundation
import Model

public protocol QuestionRepositoryProtocol {
    func fetchQuestionList(page: Int, pageSize: Int) async throws -> QuestionModel?
}
