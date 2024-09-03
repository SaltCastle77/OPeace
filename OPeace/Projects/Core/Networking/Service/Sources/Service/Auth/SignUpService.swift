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
    case signUpJob
    case updateUserInfo(
        nickname: String,
        year: Int,
        job: String,
        generation: String
    )
    case checkGeneration(year: Int)
    case getGenerationList
}


extension SignUpService: BaseTargetType {
    
    public var path: String {
        switch self {
        case .nickNameCheck:
            return SignUpAPI.nickNameCheck.signUpAPIDesc
            
        case .signUpJob:
            return SignUpAPI.signUpJob.signUpAPIDesc
            
        case .updateUserInfo:
            return SignUpAPI.updateProfile.signUpAPIDesc
            
        case .checkGeneration:
            return SignUpAPI.checkGeneration.signUpAPIDesc
            
        case .getGenerationList:
            return SignUpAPI.getGenerations.signUpAPIDesc
        }
    }
    
    
    public var method: Moya.Method {
        switch self {
        case .nickNameCheck:
            return .get
            
        case .signUpJob:
            return .get
            
        case .updateUserInfo:
            return .patch
            
        case .checkGeneration:
            return .get
            
        case .getGenerationList:
            return .get
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .nickNameCheck(let nickname):
            let parameters: [String: Any] = [
                "nickname": nickname
            ]
            return parameters
        case .signUpJob:
            return .none
        case .updateUserInfo(
            let nickname,
            let year,
            let job,
            let generation):
            let parameters: [String: Any] = [
                "nickname": nickname,
                "year": year,
                "job": job,
                "generation": generation
            ]
            return parameters
        case .checkGeneration(let year):
            let parameters: [String: Any] = [
                "year": year
            ]
            return parameters
        
        case .getGenerationList:
            return .none
        }
    }
    
    public var shouldUseJSONEncodingForGet: Bool {
        switch self {
        case .updateUserInfo:
            return true
        default:
            return false
        }
    }
    
    public var shouldUseQueryStringEncodingForGet: Bool {
        switch self {
        case .checkGeneration:
            return true
        default:
            return false
        }
    }
    
    
    public var headers: [String : String]?{
        switch self {
        case .updateUserInfo:
            return APIHeader.baseHeader
            
        default:
            return APIHeader.notAccessTokenHeader
        }
    }
}
