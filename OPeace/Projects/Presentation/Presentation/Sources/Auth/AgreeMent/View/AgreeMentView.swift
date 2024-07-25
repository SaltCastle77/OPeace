//
//  AgreeMentView.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

public struct AgreeMentView: View {
    @Bindable var store: StoreOf<AgreeMent>
    var backAction: () -> Void = { }
    
    
    public init(
        store: StoreOf<AgreeMent>,
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
                
                agreeMentTitle()
                
                agreeCheckBox()
                
                Spacer()
                    .frame(height: UIScreen.screenHeight * 0.35)
                
                CustomButton(
                    action: {
                        store.send(.navigation(.presntSignUpName))
                    }, title: store.nextButtonTitle,
                    config: CustomButtonConfig.create()
                    ,isEnable: store.enableNextButton
                )
                .padding(.horizontal, 20)
                
                
                Spacer()
                    .frame(height: 16)
                
            }
        }
    }
}

extension AgreeMentView {
    
    @ViewBuilder
    private func agreeMentTitle() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.06)
            
            HStack {
                Spacer()
                
                Text(store.agreeMentTilteText)
                    .foregroundStyle(Color.basicWhite)
                    .pretendardFont(family: .SemiBold, size: 24)
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 16)
            
            HStack {
                Spacer()
                
                Text(store.agreeMentSubTitleText)
                    .foregroundStyle(Color.gray300)
                    .pretendardFont(family: .Regular, size: 16)
                
                Spacer()
            }
            
        }
    }
    
    
    @ViewBuilder
    private func agreeCheckBox() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.08)
            
            CheckTitleView(
                action: {
                    store.send(.view(.allAgreeCheckTapped))
                }, goWebView: {
                    
                },
                text: store.allAgreeMentText,
                isChecked: store.allAgreeCheckState,
                isAreemnetAll: true
            )
            
            Spacer()
                .frame(height: 20)
            
            CheckTitleView(
                action: {
                    store.send(.view(.ageAgreeCheckTappd))
                }, goWebView: {
                    
                },
                text: store.ageAgreeCheckTitle,
                isChecked: store.ageAgreeCheckState,
                isEssentialAgree: true)
            
            Spacer()
                .frame(height: 20)
            
            CheckTitleView(
                action: {
                    store.send(.view(.serviceAgreeCheckTapped))
                }, goWebView: {
                    store.send(.navigation(.presntServiceAgreeCheckTapped))
                },
                text: store.serviceAgreeCheckTitle,
                isChecked: store.serviceAgreeCheckState,
                isActiveUnderline: true
            )
            
            Spacer()
                .frame(height: 20)
            
            CheckTitleView(
                action: {
                    store.send(.view(.privacyAgreeCheckTapped))
                }, goWebView: {
                    store.send(.navigation(.presntPrivacyAgreeCheckTapped))
                },
                text: store.privacyAgreeCheckTitle,
                isChecked: store.privacyAgreeCheckState,
                isActiveUnderline: true)
            
            
        }
    }
}
