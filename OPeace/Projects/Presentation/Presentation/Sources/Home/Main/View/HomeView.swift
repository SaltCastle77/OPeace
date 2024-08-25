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
                appearFloatingPopUp()
            }
            .introspect(.navigationStack, on: .iOS(.v17, .v18)) { navigationController in
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            }
            
            VStack {
                Spacer()
                
                writeQuestionButton()
                    .padding(.bottom, 20) 
            }
            .edgesIgnoringSafeArea(.bottom)
            
            
        }
        
        
        .popup(item: $store.scope(state: \.destination?.customPopUp, action: \.destination.customPopUp)) { customPopUp in
            if store.isLogOut == true || store.isLookAround == true || store.isDeleteUser == true {
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
                
                RightImageButton(action: {
                    store.send(.view(.firstFilterTapped))
                }, title: "계열")
                .sheet(item: $store.scope(state: \.destination?.homeFilter, action: \.destination.homeFilter)) { homeFilterStore in
                    HomeFilterView(store: homeFilterStore)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.automatic)
                }
                
                
                RightImageButton(action: {
                    
                }, title: "세대")
                
                RightImageButton(action: {
                    
                }, title: "최신순")

                if store.isLogOut == true || store.isLookAround == true || store.isDeleteUser == true {
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
    
    private func appearFloatingPopUp() {
        if store.isLogOut == true  {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "로그아웃 되었어요"
            store.send(.view(.timeToCloseFloatingPopUp))
        } else if store.isLookAround == true {
            store.floatingText = "로그인 해주세요"
        } else if store.isDeleteUser == true  {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "탈퇴 완료! 언젠가 다시 만나요"
            store.send(.view(.timeToCloseFloatingPopUp))
        } else if store.isChangeProfile == true {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "수정이 완료되었어요!"
            store.send(.view(.timeToCloseFloatingPopUp))
            store.isChangeProfile = false
        } else if store.isCreateQuestion == true {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "고민 등록이 완료 되었어요!"
            store.send(.view(.timeToCloseFloatingPopUp))
            store.isCreateQuestion = false
        } else {
            store.floatingText = "로그인 해주세요"
        }
    }
    
    @ViewBuilder
    private func writeQuestionButton() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.basicWhite)
            .frame(width: 120, height: 56)
            .clipShape(Capsule())
            .overlay {
                Text("글쓰기")
                    .pretendardFont(family: .Regular, size: 20)
                    .foregroundStyle(Color.textColor100)
            }
            .onTapGesture {
                store.send(.navigation(.presntWriteQuestion))
            }
            .padding(.bottom, 16)
            
        
    }
}
