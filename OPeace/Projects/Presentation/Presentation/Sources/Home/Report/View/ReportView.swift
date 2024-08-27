//
//  ReportView.swift
//  Presentation
//
//  Created by 서원지 on 8/26/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct ReportView: View {
    @Bindable var store: StoreOf<Report>
    var backAction: () -> Void = { }
    
    public init(
        store: StoreOf<Report>,
        backAction: @escaping () -> Void
    ) {
        self.store = store
        self.backAction = backAction
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 14)
                
                CustomTitleNaviagionBackButton(buttonAction: backAction, title: "신고하기")
                
                ScrollView {
                    reportTitleView()
                    
                    reportReasonTextFieldView()
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.5)
                    
                    CustomButton(
                        action: {
                            store.send(.async(.reportQuestion(questionID: store.questionID, reason: store.reportReasonText)))
                        }, title: store.reportButtonComplete,
                        config: CustomButtonConfig.create()
                        ,isEnable: !store.reportReasonText.isEmpty
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 16)
                }
                .bounce(false)
                
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}


extension ReportView {
    
    @ViewBuilder
    private func reportTitleView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            HStack {
                Text("신고 사유를 작성해주세요")
                    .pretendardFont(family: .Bold, size: 16)
                    .foregroundStyle(Color.basicWhite)
                
                Spacer()
            }
            
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func reportReasonTextFieldView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            TextEditor(text: $store.reportReasonText)
                .modifier(TextEditorModifier(placeholder: "여기를 눌러서 작성해주세요.", text: $store.reportReasonText))
                .frame(height: 160)
            
        }
        .padding(.horizontal, 20)
    }
}
