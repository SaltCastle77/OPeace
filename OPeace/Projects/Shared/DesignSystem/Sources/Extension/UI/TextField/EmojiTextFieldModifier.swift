//
//  UIEmojiTextField.swift
//  DesignSystem
//
//  Created by 서원지 on 8/15/24.
//

import UIKit
import SwiftUI
import SwiftUIIntrospect


public struct EmojiTextFieldModifier: ViewModifier {
    @Binding var text: String

    public init(text: Binding<String>) {
        self._text = text
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                EmojiTextFieldRepresentable(text: $text)
                    .frame(height: 0)  // Set frame height to 0 to make the view invisible
                    .opacity(0)
            )
    }
}

// Convenience extension for applying the modifier
public extension View {
    func emojiTextField(text: Binding<String>) -> some View {
        self.modifier(EmojiTextFieldModifier(text: text))
    }
}
