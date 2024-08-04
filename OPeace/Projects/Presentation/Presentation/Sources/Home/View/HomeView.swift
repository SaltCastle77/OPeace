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
                guard let lastLogin = try? Keychain().get("LastLogin") else { return }
                print("lastlogin: \(lastLogin)")
                if lastLogin != "" {
                    store.send(.view(.presntFloatintPopUp))
                }
            }

        }
        
        .popup(item: $store.scope(state: \.destination?.customPopUp, action: \.destination.customPopUp)) { customPopUp in
            CustomBasicPopUpView(
                store: customPopUp,
                title: "로그인 해주세요!") {
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
        
        .popup(item: $store.scope(state: \.destination?.floatintPopUp, action: \.destination.floatintPopUp)) { floatingPopUpStore in
            FloatingPopUpView(store: floatingPopUpStore, title: "로그아웃 되었어요", image: .succesLogout)
            
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
                
                if let lastLogin = try? Keychain().get("LastLogin") {
                    if lastLogin != "" {
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
                    } else if lastLogin == "" {
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
                    else {
                        
                    }
                    
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
