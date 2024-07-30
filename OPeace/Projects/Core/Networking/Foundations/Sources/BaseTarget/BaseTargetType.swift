//
//  BaseTargetType.swift
//  Foundation
//
//  Created by 서원지 on 7/18/24.
//

import Foundation
import Moya
import API

public protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    public var baseURL: URL {
        return URL(string: BaseAPI.base.apiDesc)!
    }
    
    public var headers: [String : String]? {
        return APIHeader.notAccessTokenHeader
    }
    
}
