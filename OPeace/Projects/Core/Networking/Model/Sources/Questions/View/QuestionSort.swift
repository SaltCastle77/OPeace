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
    
    public static func fromKoreanString(_ koreanString: String) -> Self {
            switch koreanString {
            case "최신순":
                return .recent
            case "인기순":
                return .popular
            case "":
                return .empty
            default:
                return .empty // 기본값으로 .empty를 반환합니다. 필요에 따라 변경 가능합니다.
            }
        }
}
