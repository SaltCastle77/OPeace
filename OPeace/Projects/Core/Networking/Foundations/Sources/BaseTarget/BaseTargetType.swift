//
//  BaseTargetType.swift
//  Foundation
//
//  Created by 서원지 on 7/18/24.
//

import Foundation
import Moya
import API

public protocol BaseTargetType: TargetType {
//    var parameters: [String: Any]? { get }
}

extension BaseTargetType {
    public var baseURL: URL {
        return URL(string: BaseAPI.base.apiDesc)!
    }
    
    public var headers: [String : String]? {
        return APIHeader.notAccessTokenHeader
    }
    
//    public var task: Moya.Task {
//        if let parameters = parameters {
//            switch method {
//            case .get:
//                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//            case .post:
//                return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
//            case .delete:
//                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//            default:
//                return .requestPlain
//            }
//        }
//        return .requestPlain
//    }
    
}
