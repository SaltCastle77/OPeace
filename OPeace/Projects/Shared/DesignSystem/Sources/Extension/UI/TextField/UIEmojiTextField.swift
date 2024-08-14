//
//  UIEmojiTextField.swift
//  DesignSystem
//
//  Created by 서원지 on 8/15/24.
//

import UIKit

public class UIEmojiTextField: UITextField {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEmoji() {
        _ = self.textInputMode
    }
    
    public override var textInputContextIdentifier: String? {
        return ""
    }
    
    public override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default // do not remove this
                return mode
            }
        }
        return nil
    }
}
