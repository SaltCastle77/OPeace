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
                            store.send(.async(.deleteUser(reason: store.withDrawTitle)))
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
                    .pretendardFont(family: .Regular, size: 16)
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
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray500)
                .shadow(color: Color.basicBlack.opacity(0.007), radius: 0, x: 0, y: 0.04)
                .blur(radius: 0.01)
                .frame(height: 164)
                .overlay {
                    VStack {
                        Spacer()
                            .frame(height: 24)

                        TextField("여기를 눌러서 작성해주세요.", text: $store.withDrawTitle)
                            .pretendardFont(family: .Regular, size: 16)
                            .foregroundStyle(store.withDrawTitle.isEmpty ? Color.gray300 : Color.basicWhite)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal , 20)
                        
                        Spacer()
                         
                    }   
                }
            
        }
        .padding(.horizontal, 20)
    }
}
