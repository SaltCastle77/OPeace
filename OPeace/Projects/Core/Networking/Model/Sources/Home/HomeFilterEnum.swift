//
//  HomeFilterEnum.swift
//  Model
//
//  Created by 염성훈 on 8/31/24.
//

import Foundation

public enum HomeFilterEnum: Equatable {
    case job
    case generation
    case sorted(SortedEnum)
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
            }
        }
    }
}

public enum SortedEnum {
    case recent
    case popular
}
