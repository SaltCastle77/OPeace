//
//  EditQuestionType.swift
//  Model
//
//  Created by 서원지 on 8/25/24.
//

import Foundation

public enum EditQuestionType : String, CaseIterable, Equatable {
    case reportUser
    case blockUser
    
    public var editQuestionDesc: String {
        switch self {
        case .reportUser:
            return "신고하기"
        case .blockUser:
            return "차단하기"
        }
    }
}
