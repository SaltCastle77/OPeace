//
//  HomeView.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI
import DesignSystem

import ComposableArchitecture
import SwiftUIIntrospect
import PopupView
import KeychainAccess

public struct HomeView: View {
    @Bindable var store: StoreOf<Home>
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                navigationBaritem()
                
                Spacer()
            }
            .onAppear {
                if store.isLogin == true  {
                    store.send(.view(.presntFloatintPopUp))
                    store.floatingText = "로그아웃 되었어요"
                } else if store.isLookAround == true {
                    store.floatingText = "로그인 해주세요"
                } else if store.isDeleteUser == true  {
                    store.send(.view(.presntFloatintPopUp))
                    store.floatingText = "탈퇴 완료! 언젠가 다시 만나요"
                } else {
                    store.floatingText = "로그아웃 되었어요"
                    
                }
            }

        }
        
        .popup(item: $store.scope(state: \.destination?.customPopUp, action: \.destination.customPopUp)) { customPopUp in
            CustomBasicPopUpView(
                store: customPopUp,
                title: store.floatingText) {
                    store.send(.view(.closePopUp))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        store.send(.navigation(.presntLogin))
                    }

            } cancelAction: {
                store.send(.view(.closePopUp))
            }
            
        }  customize: { popup in
            popup
                .type(.floater(verticalPadding: UIScreen.screenHeight * 0.35))
                .position(.bottom)
                .animation(.spring)
                .closeOnTap(true)
                .closeOnTapOutside(true)
                .backgroundColor(Color.basicBlack.opacity(0.8))
        }
        
        .popup(item: $store.scope(state: \.destination?.floatingPopUP, action: \.destination.floatingPopUP)) { floatingPopUpStore in
            FloatingPopUpView(store: floatingPopUpStore, title: store.floatingText.isEmpty ? "로그아웃 되었어요" : store.floatingText, image: .succesLogout)
            
        }  customize: { popup in
            popup
                .type(.floater(verticalPadding: UIScreen.screenHeight * 0.02))
                .position(.bottom)
                .animation(.spring)
                .closeOnTap(true)
                .closeOnTapOutside(true)
        }
    }
}

extension HomeView {
    
    @ViewBuilder
    private func navigationBaritem() -> some View {
        LazyVStack {
            Spacer()
                .frame(height: 22)
            
            HStack {
                Spacer()
                
                if store.isLogin == true || store.isLookAround == true || store.isDeleteUser == true {
                    Circle()
                        .fill(Color.gray500)
                        .frame(width: 40, height: 40)
                        .overlay {
                            VStack{
                                Image(systemName: store.profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 16)
                                    .foregroundStyle(Color.gray200)
                                    
                            }
                        }
                        .onTapGesture {
                            store.send(.view(.prsentLoginPopUp))
                        }
                } else {
                    Circle()
                        .fill(Color.gray500)
                        .frame(width: 40, height: 40)
                        .overlay {
                            VStack{
                                Image(systemName: store.profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 16)
                                    .foregroundStyle(Color.gray200)
                                    
                            }
                        }
                        .onTapGesture {
                            store.send(.navigation(.presntProfile))
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
