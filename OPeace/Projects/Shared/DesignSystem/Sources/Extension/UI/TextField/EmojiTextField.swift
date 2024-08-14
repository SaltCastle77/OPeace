//
//  EmojiTextField.swift
//  DesignSystem
//
//  Created by 서원지 on 8/15/24.
//

import SwiftUI

public struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var emojiImage: Image?
    @Binding var isInputEmoji: Bool
    public var placeholder: String = ""
    
    public init(
        text: Binding<String>,
        emojiImage: Binding<Image?>,
        isInputEmoji: Binding<Bool>,
        placeholder: String) {
        self._text = text
        self._emojiImage = emojiImage
        self._isInputEmoji = isInputEmoji
        self.placeholder = placeholder
    }
    
    public func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        emojiTextField.font = UIFont.systemFont(ofSize: 48)
        emojiTextField.returnKeyType = .done  // Set the return key type to 'Done'
        return emojiTextField
    }
    
    public func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
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
                
                // When an emoji is selected, convert it to an image and exit emoji input mode
                if newValue.count == 1, newValue.unicodeScalars.allSatisfy({ $0.properties.isEmoji }) {
                    self.parent.emojiImage = Image.emojiToImage(emoji: newValue)
                    self.parent.isInputEmoji = false
                } else {
                    self.parent.text = ""
                    textField.text = ""
                }
            }
        }
        
        // Handle the return key press
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()  // Dismiss the keyboard
            return true
        }
    }
}
