//
//  TextEditorModifier.swift
//  DesignSystem
//
//  Created by 서원지 on 8/15/24.
//

import SwiftUI
import Utill

public struct TextEditorModifier : ViewModifier {
    let placeholder: String
    @Binding var text: String
    
    
    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(15)
            .background(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .padding(.top, 24)
                        .padding(.horizontal ,24)
                        .pretendardFont(family: .Regular, size: 16)
                        .foregroundColor(Color.gray300)
                }
            }
            .foregroundStyle(Color.basicWhite)
            .textInputAutocapitalization(.none) // 첫 시작 대문자 막기
            .autocorrectionDisabled()
            
            .background(Color.gray500)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scrollContentBackground(.hidden)
            .pretendardFont(family: .Regular, size: 16)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
    
}
