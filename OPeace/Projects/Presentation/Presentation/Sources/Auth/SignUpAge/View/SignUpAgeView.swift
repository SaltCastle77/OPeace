//
//  SignUpAgeView.swift
//  Presentation
//
//  Created by 서원지 on 7/26/24.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem
import Utill


public struct SignUpAgeView: View {
    @Bindable var store: StoreOf<SignUpAge>
    var backAction: () -> Void = { }
    
    public init(
        store: StoreOf<SignUpAge>,
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
                
                NavigationBackButton(buttonAction: backAction)
                
                Spacer()
                    .frame(height: 27)
                
                DotBarView(activeIndex: $store.selectedTab, totalDots: store.totalTabs)
                
                ScrollView(.vertical, showsIndicators: false) {
                    signUpAgeTitle()
                    
                    signUpAgeTextField()
                    
                    chekcAgeErrorText()
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.35)
                    
                    CustomButton(
                        action: {
                            
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
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                if !CheckRegister.containsInvalidAge(store.signUpAgeDisplay) {
                    store.enableButton = false
                    store.isErrorGenerationText = "정확한 연도를 입력해 주세요"
                } else if store.signUpAgeDisplay.isEmpty {
                    store.isErrorGenerationText = "정확한 연도를 입력해 주세요"
                    store.enableButton = false
                } else {
                    store.enableButton = true
                    store.isErrorGenerationText = ""
                }
                let (generation, color, textColor) = CheckRegister.getGeneration(year: Int(store.signUpAgeDisplay) ?? .zero, color: store.signUpAgeDisplayColor, textColor: store.checkGenerationTextColor)
                store.checkGenerationText = generation
                store.signUpAgeDisplayColor = color
                store.checkGenerationTextColor = textColor
                
            }
            
        }
    }
}

extension SignUpAgeView {
    
    @ViewBuilder
    private func signUpAgeTitle() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.02)
            
            Text(store.signUpAgeTitle)
                .pretendardFont(family: .SemiBold, size: 24)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 16)
            
            Text(store.signUpAgeSubTitle)
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray300)
            
            
        }
    }
    
    @ViewBuilder
    private func signUpAgeTextField() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.08)
            
            TextField("YYYY", text: $store.signUpAgeDisplay)
                .pretendardFont(family: .SemiBold, size: 48)
                .foregroundStyle((Int(store.signUpAgeDisplay) == nil) ? Color.gray300 : Color.basicWhite)
                .multilineTextAlignment(.center)
                .submitLabel(.return)
                .keyboardType(.numberPad)
                .onSubmit {
                    if CheckRegister.containsInvalidCharacters(store.signUpAgeDisplay) {
                        store.isErrorGenerationText = "정확한 연도를 입력해 주세요"
                    } else if store.signUpAgeDisplay.isEmpty {
                        store.isErrorGenerationText = "정확한 연도를 입력해 주세요"
                    } else {
                        store.isErrorGenerationText = ""
                    }
                    let (generation, color, textColor) = CheckRegister.getGeneration(year: Int(store.signUpAgeDisplay) ?? .zero, color: store.signUpAgeDisplayColor, textColor: store.checkGenerationTextColor)
                    store.checkGenerationText = generation
                    store.signUpAgeDisplayColor = color
                    store.checkGenerationTextColor = textColor
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            HStack {
                Spacer()
                
                if store.signUpAgeDisplay.isEmpty {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.gray500)
                        .frame(width: 70, height: 32)
                        .overlay {
                            Text("? 세대")
                                .pretendardFont(family: .Regular, size: 16)
                                .foregroundStyle(Color.gray200)
                        }
                } else {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(store.signUpAgeDisplayColor)
                        .frame(width: 90, height: 32)
                        .overlay {
                            Text(store.checkGenerationText)
                                .pretendardFont(family: .Regular, size: 16)
                                .foregroundStyle(store.checkGenerationTextColor)
                        }
                }
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func chekcAgeErrorText() -> some View {
        VStack {
            Spacer()
                .frame(height: 20)
            
            if store.signUpAgeDisplay.isEmpty {
                Text(store.isErrorGenerationText)
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(store.enableButton ? Color.basicPrimary : Color.alertError)
            } else {
                Text(store.isErrorGenerationText)
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(store.enableButton ? Color.basicPrimary : Color.alertError)
            }
            
            
        }
    }
}
