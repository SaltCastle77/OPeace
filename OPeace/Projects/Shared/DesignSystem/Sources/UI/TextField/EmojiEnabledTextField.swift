//
//  EmojiEnabledTextField.swift
//  DesignSystem
//
//  Created by 서원지 on 8/27/24.
//

import UIKit

@MainActor
public class EmojiEnabledTextField: UITextField {
    public override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return super.textInputMode
    }
}
