//
//  AuthView.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem

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
                
            case .agreeMent(let AgreeMentStore):
                AgreeMentView(store: AgreeMentStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
            }
        }

    }
}
