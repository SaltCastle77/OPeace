//
//  AppView.swift
//  OPeace
//
//  Created by 서원지 on 7/21/24.
//

import SwiftUI
import ComposableArchitecture

import Presentation

public struct AppView: View {
    @Bindable var store: StoreOf<AppReducer>
    @Shared(.appStorage("lastViewedPage")) var lastViewedPage: Int = .zero
    
    public var body: some View {
        SwitchStore(store) { state in
            switch state {
            case .splash:
                if let store = store.scope(state: \.splash, action: \.view.splash) {
                    SplashView(store: store)
                }
                
            case .auth:
                if let store = store.scope(state: \.auth, action: \.view.auth) {
                    AuthView(store: store)
                }
                    
                
            case .main:
                if let store = store.scope(state: \.main, action: \.view.main) {
                    HomeCoordinatorView(store: store)
                        .onAppear {
                            lastViewedPage = .zero
                        }
                }
            }
        }
        .onAppear {
            store.send(.view(.presntView))
        }
    }
}


#Preview {
    AppView(store: Store(
        initialState: AppReducer.State(),
        reducer: {
        AppReducer()
    }))
}
