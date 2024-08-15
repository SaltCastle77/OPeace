//
//  RoundTextField.swift
//  DesignSystem
//
//  Created by 서원지 on 8/15/24.
//

import SwiftUI
import Utill

public struct RoundTextField: View {
    private var choiceTitle: String
    private var placeholder: String
    private var completion: (String) -> Void
    private var subitAction: () -> Void = { }
    
    @Binding private var choiceAnswerText: String
    @Binding private var isErrorStoke: Bool
    
    public init(
        choiceTitle: String,
        placeholder: String,
        choiceAnswerText: Binding<String>,
        isErrorStoke: Binding<Bool>,
        completion: @escaping (String) -> Void,
        subitAction: @escaping () -> Void
    ) {
        self.choiceTitle = choiceTitle
        self.placeholder = placeholder
        self._choiceAnswerText = choiceAnswerText
        self._isErrorStoke = isErrorStoke
        self.completion = completion
        self.subitAction = subitAction
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .stroke(isErrorStoke ? Color.alertError : Color.clear, lineWidth: 1)
            .frame(height: 48)
            .background(Color.gray400)
            .cornerRadius(30)
            .overlay(
                HStack {
                    Spacer()
                        .frame(width: 16)
                    
                    Text(choiceTitle)
                        .pretendardFont(family: .Regular, size: 16)
                        .foregroundStyle(Color.gray200)
                    
                    Spacer()
                    
                    TextField(placeholder, text: $choiceAnswerText)
                        .pretendardFont(family: .Regular, size: 16)
                        .foregroundStyle(Color.basicWhite)
                        .multilineTextAlignment(.center)
                        .onChange(of: choiceAnswerText) { oldValue, newValue in
                            completion(newValue)
                        }
                        .onSubmit {
                            UIApplication.shared.hideKeyboard()
                            subitAction()
                        }
                    
                    Spacer()
                        .frame(width: 16)
                }
                .frame(maxWidth: .infinity)
            )
            .padding(.horizontal, 40)
    }
}
