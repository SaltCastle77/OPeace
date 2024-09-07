//
//  QuestionSort.swift
//  Model
//
//  Created by 서원지 on 8/23/24.
//

import Foundation

public enum QuestionSort: String, CaseIterable {
    case recent
    case popular
    case empty
    
    public var questionSortDesc: String {
        switch self {
        case .recent:
            return "latest"
        case .popular:
            return "oldest"
        case .empty:
            return ""
        }
    }
    
    public var sortedKoreanString: String {
        switch self {
        case .recent:
            return "최신순"
        case .popular:
            return "인기순"
        case .empty:
            return ""
        }
    }
}
