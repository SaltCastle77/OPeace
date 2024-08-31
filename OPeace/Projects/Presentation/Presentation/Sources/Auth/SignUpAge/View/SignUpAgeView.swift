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
    
    public init(
        store: StoreOf<SignUpAge>
    ) {
        self.store = store
        
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    signUpAgeTitle()
                    
                    signUpAgeTextField()
                    
                    chekcAgeErrorText()
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.352)
                    
                    CustomButton(
                        action: {
                            store.send(.async(.fetchJobList))
                            Task {
                                try await Task.sleep(nanoseconds: UInt64(5))
                                 store.send(.switchTabs)
                            }
                            
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
            .onAppear {
                store.send(.view(.apperName))
            }
            .onChange(of: store.signUpAgeDisplay, { oldValue, newValue in
                store.send(.async(.checkGeneration(year: Int(newValue) ?? .zero)))
                
//                let (color, textColor) = CheckRegister.getGenerationSignUp(
//                    generation: store.checkGenerationText,
//                    color: store.signUpAgeDisplayColor,
//                    textColor: store.checkGenerationTextColor)
////                        store.checkGenerationText = generation
//                store.signUpAgeDisplayColor = color
//                store.checkGenerationTextColor = textColor

            })
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                if !CheckRegister.containsInvalidAge(store.signUpAgeDisplay) {
                    store.enableButton = false
                    store.isErrorGenerationText = "정확한 연도를 입력해 주세요"
                } else if store.signUpAgeDisplay.isEmpty ||  store.signUpAgeDisplay.count != 4 || Int(store.signUpAgeDisplay) == nil {
                    store.isErrorGenerationText = "정확한 연도를 입력해 주세요"
                    store.enableButton = false
                } else if let year = Int(store.signUpAgeDisplay), year < 1900 {
                    store.isErrorGenerationText = "연도는 1900년 이상이어야 합니다"
                    store.enableButton = false
                } else {
                    store.enableButton = true
                    store.isErrorGenerationText = ""
                }
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
                .onChange(of: store.signUpAgeDisplay) { newValue in
                    if newValue.count > 4 {
                        store.signUpAgeDisplay = String(newValue.prefix(4))
                    }
                    store.signUpAgeDisplay = store.signUpAgeDisplay.filter { $0.isNumber }
                    store.send(.async(.checkGeneration(year: Int(newValue) ?? .zero)))
                }
                .onSubmit {
                    // Check if the input is exactly 4 digits and can be converted to an integer
                    if store.signUpAgeDisplay.count != 4 || Int(store.signUpAgeDisplay) == nil {
                        store.isErrorGenerationText = "정확한 연도를 입력해 주세요"
                    } else if let year = Int(store.signUpAgeDisplay), year < 1900 {
                        store.isErrorGenerationText = "연도는 1900년 이상이어야 합니다"
                        store.enableButton = false
                    } else {
                        // No error, so proceed with generation check
                        store.isErrorGenerationText = ""
                        store.send(.async(.checkGeneration(year: Int(store.signUpAgeDisplay) ?? .zero)))
                        
//                        let (color, textColor) = CheckRegister.getGenerationSignUp(
//                            generation: store.checkGenerationText,
//                            color: store.signUpAgeDisplayColor,
//                            textColor: store.checkGenerationTextColor)
////                        store.checkGenerationText = generation
//                        store.signUpAgeDisplayColor = color
//                        store.checkGenerationTextColor = textColor
                    }
                }

            
            HStack {
                Spacer()
                
                if store.signUpAgeDisplay.isEmpty {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.gray500)
                        .frame(width: "기타 세대".calculateWidthAge(for: "기타 세대"), height: 32)
                        .overlay {
                            Text("기타 세대")
                                .pretendardFont(family: .Regular, size: 16)
                                .foregroundStyle(Color.gray200)
                        }
                } else {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(store.signUpAgeDisplayColor)
                        .frame(width: store.checkGenerationText.calculateWidthAge(for: store.checkGenerationText), height: 32)
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
            } else  if let year = Int(store.signUpAgeDisplay), year < 1900 || store.signUpAgeDisplay.count != 4 {
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
