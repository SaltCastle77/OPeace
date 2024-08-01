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
    
    public var body: some View {
        SwitchStore(store) { state in
            switch state {
            case .splash:
                if let store = store.scope(state: \.splash, action: \.view.splash) {
                    SplashView(store: store)
                }
                    
                
            case .root:
                if let store = store.scope(state: \.root, action: \.view.root) {
                    RootView(store: store)
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
