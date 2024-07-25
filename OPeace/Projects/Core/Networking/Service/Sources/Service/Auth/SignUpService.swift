//
//  SignUpService.swift
//  Service
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

import API
import Utills

import Moya
import Foundations

public enum SignUpService {
    case nickNameCheck(nickname: String)
}


extension SignUpService: BaseTargetType {
    
    public var path: String {
        switch self {
        case .nickNameCheck:
            return SignUpAPI.nickNameCheck.signUpAPIDesc
        }
    }
    
    
     public var method: Moya.Method {
        switch self {
        case .nickNameCheck:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .nickNameCheck(let nickname):
            let parameters: [String: Any] = ["nickname": nickname]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
