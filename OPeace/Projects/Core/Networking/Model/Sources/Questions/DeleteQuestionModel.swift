//
//  DeleteQuestionModel.swift
//  Model
//
//  Created by 서원지 on 8/26/24.
//

import Foundation

public struct DeleteQuestionModel: Codable, Equatable {
    public let data: DeleteQuestionResponseModel?
    
    public init(
        data: DeleteQuestionResponseModel?
    ) {
        self.data = data
    }
}

// MARK: - DataClass
public struct DeleteQuestionResponseModel: Codable, Equatable {
    public let status: Bool?
    public let message: String?
    
    public init(
        status: Bool?,
        message: String?
    ) {
        self.status = status
        self.message = message
    }
}
