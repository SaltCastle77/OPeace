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
    
    @discardableResult
    public static func isValidEmojiOnlyText(_ input: String) -> Bool {
        let emojiRegex = "^[\\p{Emoji}\\p{Emoji_Presentation}\\p{Emoji_Modifier}\\p{Emoji_Modifier_Base}\\p{Emoji_Component}\\u{FE0F}]+$"
                let predicate = NSPredicate(format: "SELF MATCHES %@", emojiRegex)
                return predicate.evaluate(with: input)
    }
    
    @discardableResult
    public static func containsInappropriateLanguage(_ input: String) -> Bool {
        let inappropriateLanguageRegex = "[시씨씌슈쓔쉬쉽쒸쓉]([0-9]*)[바발벌빠빡빨뻘파팔펄]"
        let predicate = NSPredicate(format: "SELF MATCHES %@", inappropriateLanguageRegex)
        return predicate.evaluate(with: input)
    }
}
