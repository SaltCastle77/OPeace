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

public struct AuthView: View {
    @Bindable var store: StoreOf<Auth>
    
    public init(
        store: StoreOf<Auth>
    ) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            LoginView(
                store: Store(initialState: Login.State(),
                             reducer: {
                Login()
            }))
            .onAppear {
                store.send(.view(.appearPath))
            }
        } destination: { swithStore in
            switch swithStore.case {
            case .login(let loginStore):
                LoginView(store: loginStore)
                    .navigationBarBackButtonHidden()
                
            case .agreeMent(let agreeMentStore):
                AgreeMentView(store: agreeMentStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
                
            case .webView(let webViewStore):
                WebViews(store: webViewStore)
                    .navigationBarBackButtonHidden()
                
            case .signUpPagging(let signUpPaggingStore):
                SignUpPagingView(store: signUpPaggingStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .root(let rootStore):
                RootView(store: rootStore)
                    .navigationBarBackButtonHidden()
            }
        }

    }
}
