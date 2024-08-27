//
//  QuestionSort.swift
//  Model
//
//  Created by 서원지 on 8/23/24.
//

import Foundation

public enum QuestionSort: String, CaseIterable {
    case latest
    case oldest
    case empty
    
    public var questionSortDesc: String {
        switch self {
        case .latest:
            return "latest"
        case .oldest:
            return "oldest"
        case .empty:
            return ""
        }
    }
}
