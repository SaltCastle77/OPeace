//
//  CrateQuestionUserModel.swift
//  Model
//
//  Created by 서원지 on 10/1/24.
//

import Foundation

public struct CreateQuestionUserModel: Equatable {
    public var createQuestionEmoji: String
    public var createQuestionTitle: String
    
    public init(
        createQuestionEmoji: String = "",
        createQuestionTitle: String = ""
    ) {
        self.createQuestionEmoji = createQuestionEmoji
        self.createQuestionTitle = createQuestionTitle
    }
}
