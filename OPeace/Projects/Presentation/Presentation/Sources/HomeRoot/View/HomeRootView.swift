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
                   
            case .profile(let profileStore):
                ProfileView(store: profileStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
              
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
                
            case .onBoardingPagging(let onBoardingPaggingStore):
                OnBoadingPaggingView(store: onBoardingPaggingStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .editProfile(let editProfileStore):
                EditProfileView(store: editProfileStore) {
                    store.send(.inner(.removePath))
                } backToHomeAction: {
                    store.send(.inner(.removeToHome))
                }
                .navigationBarBackButtonHidden()
                
            case .withDraw(let withDrawStore):
                WithDrawView(store: withDrawStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()

            case .writeQuestion(let writeQuestionStore):
                WriteQuestionView(store: writeQuestionStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .writeAnswer(let writeAnswerStore):
                WriteAnswerView(store: writeAnswerStore) {
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
