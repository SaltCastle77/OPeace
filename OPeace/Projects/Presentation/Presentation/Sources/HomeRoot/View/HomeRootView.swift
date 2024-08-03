//
//  RootView.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import SwiftUIIntrospect

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
                    .introspect(.navigationStack, on: .iOS(.v17, .v18)) { navigationController in
                        navigationController.interactivePopGestureRecognizer?.isEnabled = false
                    }
                   
                
            case .profile(let profileStore):
                ProfileView(store: profileStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                .introspect(.navigationStack, on: .iOS(.v17, .v18)) { navigationController in
                    navigationController.interactivePopGestureRecognizer?.isEnabled = true
                }
              
            
            case .login(let loginStore):
                LoginView(store: loginStore)
                    .navigationBarBackButtonHidden()
                
            case .editProfile(let editProfileStore):
                EditProfileView(store: editProfileStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            }
        }
        .introspect(.navigationStack, on: .iOS(.v17, .v18)) { navigationController in
            if store.path.contains(.home(.init())) {
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            } else if store.path.contains(.login(.init())) {
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            } else if store.path.contains(.profile(.init())) {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
            } else {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
            }
        }

    }
}
