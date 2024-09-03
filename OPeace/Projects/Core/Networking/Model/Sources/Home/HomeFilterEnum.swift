//
//  HomeFilterEnum.swift
//  Model
//
//  Created by 염성훈 on 8/31/24.
//

import Foundation

public enum HomeFilterEnum: Equatable, Hashable {
    case job
    case generation
    case sorted(QuestionSort)
}

extension HomeFilterEnum: CaseIterable {
    public static var allCases: [HomeFilterEnum] {
           return [.job, .generation, .sorted(.recent), .sorted(.popular)]
       }
}


extension HomeFilterEnum {
    public var titleText: String {
        switch self {
        case .job:
            return "계열"
        case .generation:
            return "세대"
        case .sorted(let sortedEnum):
            switch sortedEnum {
            case .recent:
                return "최신순"
            case .popular:
                return "인기순"
            case .empty:
                return ""
            }
        }
    }
}

public enum SortedEnum: Equatable, CaseIterable, Hashable {
    case recent
    case popular
}
