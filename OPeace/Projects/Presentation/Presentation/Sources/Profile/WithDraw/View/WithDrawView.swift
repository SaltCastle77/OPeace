//
//  WithDrawView.swift
//  Presentation
//
//  Created by 서원지 on 8/12/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct WithDrawView: View {
    @Bindable var store:  StoreOf<WithDraw>
    
    var backAction: () -> Void = { }
    
    public init(
        store: StoreOf<WithDraw>,
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
                
                CustomTitleNaviagionBackButton(buttonAction: backAction, title: "마이페이지")
                
                ScrollView {
                    withDrawTitleView()
                    
                    withDrawReasonTextFieldView()
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.5)
                    
                    CustomButton(
                        action: {
                            store.send(.async(.deletUserSocialType(reason: store.withDrawTitle)))
                        }, title: store.withDrawButtonComplete,
                        config: CustomButtonConfig.create()
                        ,isEnable: !store.withDrawTitle.isEmpty
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

extension WithDrawView {
    
    @ViewBuilder
    private func withDrawTitleView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            HStack {
                Text("탈퇴 사유를 작성해주세요")
                    .pretendardFont(family: .Bold, size: 16)
                    .foregroundStyle(Color.basicWhite)
                
                Spacer()
            }
            
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func withDrawReasonTextFieldView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            TextEditor(text: $store.withDrawTitle)
                .modifier(TextEditorModifier(placeholder: "여기를 눌러서 작성해주세요.", text: $store.withDrawTitle))
                .frame(height: 160)
            
        }
        .padding(.horizontal, 20)
    }
}
