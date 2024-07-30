//
//  SignUpAPI.swift
//  API
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

public enum SignUpAPI : String{
    case nickNameCheck
    case signUpJob
    case updateProfile
    
    
    public  var signUpAPIDesc: String {
        switch self {
        case .nickNameCheck:
            return "/users/nickname-check/"
            
        case .signUpJob:
            return "/users/jobs/"
            
        case .updateProfile:
            return "/users/"
        }
    }
}
