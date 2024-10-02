//
//  AuthView.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem
import KakaoSDKAuth
import SwiftUIIntrospect
import TCACoordinators

public struct AuthView: View {
    @Bindable var store: StoreOf<AuthCoordinator>
    
    public init(
        store: StoreOf<AuthCoordinator>
    ) {
        self.store = store
    }
    
    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case .login(let loginStore):
                LoginView(store: loginStore)
                    .navigationBarBackButtonHidden()
                
            case .agreeMent(let agreeMentStore):
                AgreeMentView(store: agreeMentStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .signUpPagging(let signUpPagingStore):
                SignUpPagingView(store: signUpPagingStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .webView(let webViewStore):
                WebViews(store: webViewStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .onBoardingPagging(let onboardingStore):
                OnBoadingPaggingView(store: onboardingStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
            }
        }
        .introspect(.navigationStack, on: .iOS(.v17, .v18)) { navigationController in
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}
