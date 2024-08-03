//
//  RootView.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem

public struct HomeRootView: View {
    @Bindable var store: StoreOf<HomeRoot>
    
    public init(
        store: StoreOf<HomeRoot>
    ) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            HomeView(store: self.store.scope(state: \.home, action: \.home))
                .onAppear {
                    store.send(.view(.appearPath))
                }
        } destination: { switchStore in
            switch switchStore.case {
            case .home(let homeStore):
                HomeView(store: homeStore)
                    .navigationBarBackButtonHidden()
                
            case .profile(let profileStore):
                ProfileView(store: profileStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
            
            case .login(let loginStore):
                LoginView(store: loginStore)
                    .navigationBarBackButtonHidden()
                
            }
        }

    }
}
