//
//  EmojiTextFieldRepresentable.swift
//  DesignSystem
//
//  Created by 서원지 on 8/15/24.
//

import SwiftUI
import UIKit

public struct EmojiTextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String

    public init(text: Binding<String>) {
        self._text = text
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextFieldRepresentable

        init(parent: EmojiTextFieldRepresentable) {
            self.parent = parent
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.font = UIFont.systemFont(ofSize: 48)
        textField.returnKeyType = .done

        // Configure emoji keyboard behavior
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                textField.keyboardType = .default
            }
        }
        
        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
