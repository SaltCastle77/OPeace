//
//  CheckRegister.swift
//  Utill
//
//  Created by 서원지 on 7/25/24.
//

import Foundation
import SwiftUI


public struct CheckRegister{
     
    public init() {}
  
    //MARK: - 닉네임 체크
    @discardableResult
    public static func isValidNickName(_ input: String) -> Bool {
        return input.range(of: "^[a-zA-Z0-9가-힣]{2,5}$", options: .regularExpression) != nil
    }
    
    @discardableResult
    public static func containsInvalidCharacters(_ nickname: String) -> Bool {
        return nickname.contains(" ") || nickname.range(of: "[^a-zA-Z0-9가-힣]", options: .regularExpression) != nil
    }
    
    @discardableResult
    public static func containsInvalidAge(_ age: String) -> Bool {
        let yearRegex = "^(?!0000)[0-9]{4}$"
        return age.contains(" ") || age.range(of: yearRegex, options: .regularExpression) != nil
    }
}
