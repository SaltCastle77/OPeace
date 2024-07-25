//
//  KakaoBaseTargetType.swift
//  Foundations
//
//  Created by 서원지 on 7/24/24.
//

import Foundation
import Moya
import API

public protocol KakaoBaseTargetType: TargetType {}

extension KakaoBaseTargetType {
    public var baseURL: URL {
        return URL(string: BaseAPI.base.apiDesc)!
    }
    
    public var headers: [String : String]? {
        return APIHeader.kakakoHeader
        
    }
}
