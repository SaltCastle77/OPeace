//
//  LoginView.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct LoginView: View {
    
    @Bindable var store: StoreOf<Login>
    
    public init(
        store: StoreOf<Login>
    ) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                appLogoImage()
                
                loginTypeButton()
                
                notLoginLookAroudButton()
            }
        }
    }
}

extension LoginView {
    
    @ViewBuilder
    private func appLogoImage() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.35)
            
            Image(asset: store.appLogoImage)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Spacer()
            
            
        }
    }
    
    @ViewBuilder
    private func loginTypeButton() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.15)
            
            HStack {
                Spacer()
                
                loginButton(image: store.googleLoginImage, completion: {
                    store.send(.navigation(.presnetAgreement))
                })
                
                Spacer()
                    .frame(width: 16)
                
                loginButton(image: store.appleLoginImage, completion: {})
                
                Spacer()
                    .frame(width: 16)
                
                loginButton(image: store.kakaoLoginImage, completion: {})
                
                
                Spacer()
            }
        }
        .padding(.bottom , UIScreen.screenHeight * 0.03)
    }
    
    @ViewBuilder
    private func loginButton(
        image: ImageAsset,
        completion: @escaping () -> Void
    ) -> some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 60, height: 60)
            .overlay {
                Image(asset: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            .onTapGesture {
                completion()
            }
    }
    
    @ViewBuilder
    private func notLoginLookAroudButton() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            Text(store.notLogingLookAroundText)
                .pretendardFont(family: .SemiBold, size: .body3)
                .foregroundStyle(Color.gray300)
                .underline(true ,color: Color.gray300)
            
            Spacer()
                .frame(height: 22)
        }
        
    }
    
    
}
