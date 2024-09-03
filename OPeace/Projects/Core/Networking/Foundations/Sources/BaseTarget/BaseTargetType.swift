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
    var parameters: [String: Any]? { get }
    var shouldUseJSONEncodingForGet: Bool { get }
    var shouldUseQueryStringEncodingForGet: Bool { get }
}

extension BaseTargetType {
    public var baseURL: URL {
        return URL(string: BaseAPI.base.apiDesc)!
    }
    
    public var headers: [String: String]? {
        return APIHeader.notAccessTokenHeader
    }
    
    public var task: Moya.Task {
        if let parameters = parameters {
            switch method {
            case .get:
                if shouldUseJSONEncodingForGet {
                    return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
                } else if shouldUseQueryStringEncodingForGet {
                    return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
                } else {
                    return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
                }
            case .post, .put, .patch:
                return .requestParameters(parameters: parameters, encoding: shouldUseJSONEncodingForGet ? JSONEncoding.default : URLEncoding.queryString)
            case .delete:
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            default:
                return .requestPlain
            }
        }
        return .requestPlain
    }
}
