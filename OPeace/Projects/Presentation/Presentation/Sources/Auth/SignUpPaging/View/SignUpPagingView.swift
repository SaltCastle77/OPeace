//
//  SignUpPagingView.swift
//  Presentation
//
//  Created by 서원지 on 7/24/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import Model
import PopupView

public struct SignUpPagingView: View {
    @Bindable var store: StoreOf<SignUpPaging>
    var backAction: () -> Void = { }
    
    
    public init(
        store: StoreOf<SignUpPaging>,
        backAction: @escaping () -> Void
    ) {
        self.store = store
        self.backAction = backAction
      
    }
    
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 14)
                
                NavigationBackButton {
                    if store.activeMenu == .signUpName {
                       backAction()
                    } else if store.activeMenu == .signUpGeneration {
                        store.activeMenu = .signUpName
                    } else {
                        store.activeMenu = .signUpGeneration
                    }
                    
                }
                
                Spacer()
                    .frame(height: 20)
                
                DotBarView(activeIndex: $store.activeMenu)
                 
                TabView(selection: $store.activeMenu) {
                    SignUpNameView(store: self.store.scope(state: \.signUpName, action: \.signUpName))
                        .tag(SignUpTab.signUpName)
                        
                    
                    SignUpAgeView(store: self.store.scope(state: \.signUpAge, action: \.signUpAge))
                        .tag(SignUpTab.signUpGeneration)
                    
                    SignUpJobView(store: self.store.scope(state: \.signUpJob, action: \.signUpJob), confirmAction: {
                        store.send(.view(.appearPopUp))
                    })
                        .tag(SignUpTab.signUpJob)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.none, value: store.activeMenu)
                
                Spacer()
            }
            
        }
        .popup(item: $store.scope(state: \.destination?.customPopUp, action: \.destination.customPopUp), itemView: { customPopUpStore in
            CheckSignUpPopUp(
                store: customPopUpStore,
                nickName: store.signUpName.signUpNameDisplay,
                yearOfBirth: store.signUpAge.signUpAgeDisplay,
                job: store.signUpJob.selectedJob ?? "",
                confirmButtonText: "가입하기",
                cancelAction: {
                    store.send(.view(.closePopUp))
                }, confirmAction: {
                    store.send(.async(.updateUserInfo(
                        nickName: store.signUpName.signUpNameDisplay,
                        year: Int(store.signUpAge.signUpAgeDisplay) ?? 0 ,
                        job: store.signUpJob.selectedJob ?? "",
                        generation: store.signUpAge.checkGenerationText)))
                }
                
            )
        }, customize: { popup in
            popup
                .type(.floater(verticalPadding: UIScreen.screenHeight * 0.2))
                .position(.bottom)
                .animation(.spring)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .backgroundColor(Color.basicBlack.opacity(0.8))
        })
        
    }
}

