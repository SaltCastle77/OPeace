//
//  SignUpNameView.swift
//  Presentation
//
//  Created by 서원지 on 7/24/24.
//

import SwiftUI

import ComposableArchitecture

import Utill
import DesignSystem

public struct SignUpNameView: View {
    @Bindable var store: StoreOf<SignUpName>
    
    public init(
        store: StoreOf<SignUpName>
        
    ) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    signUpNameTitle()
                      
                    checkNickNameTextField()
                    
                    erorNIckCheckText()
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.4)
                    
                    CustomButton(
                        action: {
                            store.send(.switchSettingTab)
                        }, title: store.presntNextViewButtonTitle,
                        config: CustomButtonConfig.create()
                        ,isEnable: store.enableButton
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

extension SignUpNameView {
    
    @ViewBuilder
    private func signUpNameTitle() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.02)
            
            Text(store.signUpNameTitle)
                .pretendardFont(family: .SemiBold, size: 24)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 16)
            
            Text(store.signUpNameSubTitle)
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray300)
            
           
        }
    }
    
    @ViewBuilder
    private func checkNickNameTextField() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.08)
            
            TextField("닉네임", text: $store.signUpNameDisplay)
                .pretendardFont(family: .SemiBold, size: store.signUpNameDisplay.isEmpty ? 48 : 48)
                .foregroundStyle(store.signUpNameDisplay.isEmpty ? Color.gray300 : Color.basicWhite)
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .onSubmit {
                    if CheckRegister.isValidNickName(store.signUpNameDisplay) {
                        store.checkNickNameMessage = "사용 가능한 닉네임이에요"
                        
                    } else if CheckRegister.containsInvalidCharacters(store.signUpNameDisplay) {
                        store.checkNickNameMessage = "띄어쓰기와 특수문자는 사용할 수 없어요"
                    } else if store.signUpNameDisplay.isEmpty {
                        store.checkNickNameMessage = "닉네임은 5글자 이하까지 입력 가능해요"
                    } else {
                        store.checkNickNameMessage = "닉네임은 5글자 이하까지 입력 가능해요"
                    }
                }
                .onChange(of: store.signUpNameDisplay) { oldValue, newValue in
                    if CheckRegister.isValidNickName(store.signUpNameDisplay) {
                        store.send(.async(.checkNickName(nickName: newValue)))
                    } else if CheckRegister.containsInvalidCharacters(newValue) {
                        store.enableButton = false
                    } else {
                        store.enableButton = false
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
                 
        }
    }
    
    @ViewBuilder
    private func erorNIckCheckText() -> some View {
        VStack {
            Spacer()
                .frame(height: 20)
            
            if store.signUpNameDisplay.isEmpty {
                Text(store.checkNickNameMessage)
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(store.enableButton ? Color.basicPrimary : Color.alertError)
            } else {
                Text(store.checkNickNameMessage)
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(store.enableButton ? Color.basicPrimary : Color.alertError)
            }
        }
    }
    

}
