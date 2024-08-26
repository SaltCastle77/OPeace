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

public struct AuthView: View {
    @Bindable var store: StoreOf<Auth>
    
    public init(
        store: StoreOf<Auth>
    ) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            LoginView(store: self.store.scope(state: \.login, action: \.login))
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
                HomeRootView(store: rootStore)
                    .navigationBarBackButtonHidden()
                
            case .onBoardingPagging(let onBoardingPaggingStore):
                OnBoadingPaggingView(store: onBoardingPaggingStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .home(let homeStore):
                HomeView(store: homeStore)
                    .navigationBarBackButtonHidden()
                
            case .profile(let profileStore):
                ProfileView(store: profileStore) {
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
                
                
            case .writeQuestion(let writeQuestioStore):
                WriteQuestionView(store: writeQuestioStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .writeAnswer(let writeAnswerStore):
                WriteAnswerView(store: writeAnswerStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .report(let reportStore):
                ReportView(store: reportStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .blockUser(let blockUserStore):
                BlockUserView(store: blockUserStore) {
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
