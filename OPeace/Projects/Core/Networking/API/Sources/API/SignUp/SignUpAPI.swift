//
//  SignUpAPI.swift
//  API
//
//  Created by 서원지 on 7/25/24.
//

import Foundation

public enum SignUpAPI : String{
    case nickNameCheck
    
    
    public  var signUpAPIDesc: String {
        switch self {
        case .nickNameCheck:
            return "/users/nickname-check/"
        }
    }
}
