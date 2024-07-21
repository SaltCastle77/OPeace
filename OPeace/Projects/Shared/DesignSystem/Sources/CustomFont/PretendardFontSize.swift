//
//  PretendardFontSize.swift
//  DesignSystem
//
//  Created by 서원지 on 7/21/24.
//

import Foundation

public enum PretendardFontSize : Int {
    case heading1
    case heading2
    case body1
    case body2
    case body3
    case body4
    case detail1
    case detail2

    
    var fontSize: CGFloat {
        switch self {
        case .heading1:
            return 20
        case .heading2:
            return 18
        case .body1:
            return 18
        case .body2:
            return 18
        case .body3:
            return 16
        case .body4:
            return 16
        case .detail1:
            return 14
        case .detail2:
            return 14
        }
    }
    
}
