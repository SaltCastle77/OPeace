//
//  LoginView.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import Utills

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
                }, isApple: false)
                
                Spacer()
                    .frame(width: 16)
                
                loginButton(image: store.appleLoginImage, completion: {
                    
                }, isApple: true)
                
                Spacer()
                    .frame(width: 16)
                
                loginButton(image: store.kakaoLoginImage, completion: {
                    store.send(.async(.kakaoLogin))
                }, isApple: false)
                
                Spacer()
            }
        }
        .padding(.bottom , UIScreen.screenHeight * 0.03)
    }
    
    @ViewBuilder
    private func loginButton(
        image: ImageAsset,
        completion: @escaping () -> Void,
        isApple: Bool = false
    ) -> some View {
        if isApple {
            Image(asset: image)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .overlay {
                    SignInWithAppleButton(.signIn) { request in
                        var nonce = store.nonce
                        nonce = AppleLoginManger.shared.randomNonceString()
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = AppleLoginManger.shared.sha256(nonce)
                    } onCompletion: { result in
                        store.send(.async(.appleLogin(result)))
                        completion()
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .blendMode(.overlay)
                }
            
            
    
        } else {
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
                .onTapGesture {
                    UserApi.shared.unlink {(error) in
                        if let error = error {
                            Log.debug("토크 에러", error.localizedDescription)
                        }
                        else {
//                            completionHandler()
                            Log.debug("카카오 토큰 삭제")
                        }
                    }
                }
            
            Spacer()
                .frame(height: 22)
        }
        
    }
    
    
}
 
