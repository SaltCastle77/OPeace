//
//  EditQuestion.swift
//  Model
//
//  Created by 서원지 on 8/25/24.
//

import Foundation

public enum EditQuestion : String, CaseIterable {
    case reportUser
    case blockUser
    
    var editQuestionDesc: String {
        switch self {
        case .reportUser:
            return "신고하기"
        case .blockUser:
            return "차단하기"
        }
    }
}
