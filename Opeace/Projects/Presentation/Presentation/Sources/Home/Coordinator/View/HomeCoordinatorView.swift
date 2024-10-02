//
//  HomeCoordinatorView.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

import SwiftUI

import ComposableArchitecture
import DesignSystem
import SwiftUIIntrospect
import TCACoordinators

public struct HomeCoordinatorView: View {
    @Bindable var store: StoreOf<HomeCoordinator>
    
    public init(
        store: StoreOf<HomeCoordinator>
    ) {
        self.store = store
    }
    
    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
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

            case .blockUser(let blockUserStore):
                BlockUserView(store: blockUserStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .withDraw(let withDrawStore):
                WithDrawView(store: withDrawStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
                
            case .createQuestion(let createQuestionStore):
                CreateQuestionCoordinatorView(store: createQuestionStore)
                    .navigationBarBackButtonHidden()
                
            case .report(let reportStore):
                ReportView(store: reportStore) {
                    store.send(.inner(.removePath))
                }
                .navigationBarBackButtonHidden()
            }
        }
        .introspect(.navigationStack, on: .iOS(.v17, .v18)) { navigationController in
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}
