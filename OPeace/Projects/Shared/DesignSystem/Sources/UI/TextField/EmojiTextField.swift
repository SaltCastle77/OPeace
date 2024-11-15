//
//  EmojiTextField.swift
//  DesignSystem
//
//  Created by 서원지 on 8/15/24.
//

import SwiftUI
import UIKit

public struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var emojiImage: Image?
    @Binding var isInputEmoji: Bool
    @Binding var isEmojiActive: Bool
    public var placeholder: String = ""

    public init(
        text: Binding<String>,
        emojiImage: Binding<Image?>,
        isInputEmoji: Binding<Bool>,
        isEmojiActive: Binding<Bool>,
        placeholder: String = "") {
            self._text = text
            self._emojiImage = emojiImage
            self._isInputEmoji = isInputEmoji
            self._isEmojiActive = isEmojiActive
            self.placeholder = placeholder
        }
    
    public func makeUIView(context: Context) -> EmojiEnabledTextField {
        let emojiTextField = EmojiEnabledTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        emojiTextField.font = UIFont.systemFont(ofSize: 48)
        emojiTextField.returnKeyType = .done
        return emojiTextField
    }
    
    public func updateUIView(_ uiView: EmojiEnabledTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField

        init(parent: EmojiTextField) {
            self.parent = parent
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let newValue = textField.text ?? ""
                
              DispatchQueue.main.async {
                if newValue.count == 1, newValue.unicodeScalars.allSatisfy({ $0.properties.isEmoji }) {
                    self.parent.text = newValue
                    self.parent.emojiImage = Image.emojiToImage(emoji: newValue)
                    self.parent.isInputEmoji = false
                    self.parent.isEmojiActive = false
                } else if newValue.isEmpty {
                    self.parent.text = ""
                    self.parent.emojiImage = nil
                    self.parent.isInputEmoji = true
                    self.parent.isEmojiActive = true // Return to input mode
                } else {
                    self.parent.text = newValue
                    self.parent.isEmojiActive = false // Stay in input mode for non-emoji
                }
              }
            }
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
