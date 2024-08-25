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
import Utill

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
                
                questionLIstView()
                
//                Spacer()
//                    .frame(height: 10)
                
            }
            .onAppear {
                store.send(.async(.fetchQuestionList))
                appearFloatingPopUp()
            }
            .introspect(.navigationStack, on: .iOS(.v17, .v18)) { navigationController in
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            }
        
            
            VStack {
                Spacer()
                
                writeQuestionButton()
                    .padding(.bottom, 40)
            }
            .edgesIgnoringSafeArea(.bottom)
            
        }
        
        .popup(item: $store.scope(state: \.destination?.customPopUp, action: \.destination.customPopUp)) { customPopUp in
            if store.isLogOut == true || store.isLookAround == true || store.isDeleteUser == true {
                CustomBasicPopUpView(
                    store: customPopUp,
                    title: "로그인 하시겠어요?") {
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
        
        .sheet(item: $store.scope(state: \.destination?.editQuestion, action: \.destination.editQuestion)) { editQuestionStore in
            EditQuestionView(store: editQuestionStore) {
                guard let editQuestionItem = editQuestionStore.editQuestionitem else { return }
                store.send(.view(.switchModalAction(editQuestionItem )))
            } closeModalAction: {
                store.send(.view(.closeEditQuestionModal))
            }
            .presentationDetents([.height(UIScreen.screenHeight * 0.2)])
            .presentationCornerRadius(20)
            .presentationDragIndicator(.hidden)
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
            store.floatingText = "로그아웃 하시겠어요?"
            store.send(.view(.timeToCloseFloatingPopUp))
        } else if store.isLookAround == true {
            store.floatingText = "로그인 하시겠어요?"
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
            store.floatingText = "로그인 하시겠어요?"
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
                    .pretendardFont(family: .Bold, size: 20)
                    .foregroundStyle(Color.textColor100)
            }
            .onTapGesture {
                if !store.isLogOut && !store.isLookAround && !store.isDeleteUser {
                    store.send(.navigation(.presntWriteQuestion))
                } else {
                    store.send(.view(.prsentLoginPopUp))
                }
                
            }
            .padding(.bottom, 16)
            
        
    }
    
    @ViewBuilder
    private func questionLIstView() -> some View {
        VStack {
            Spacer()
                .frame(height: 15)
            
            if store.questionModel?.data?.results == [] {
                Spacer()
                
            } else {
                Spacer()
                    .frame(height: 16)
                
                qustionCardView()
                
            }
        }
    }
    
    
    @ViewBuilder
    private func qustionCardView() -> some View {
        if let resultData = store.questionModel?.data?.results {
            FlippableCardView(data: resultData) { item in
                CardItemView(
                    id: item.userInfo?.userID ?? "",
                    nickName: item.userInfo?.userNickname ?? "",
                    job: item.userInfo?.userJob ?? "",
                    generation: item.userInfo?.userGeneration ?? "",
                    generationColor: store.cardGenerationColor,
                    emoji: item.emoji ?? "",
                    title: item.title ?? "",
                    choiceA: item.choiceA ?? "",
                    choiceB: item.choiceB ?? "",
                    responseCount: item.answerCount ?? .zero,
                    likeCount: item.likeCount ?? .zero,
                    answerRatio: (A: item.answerRatio?.a ?? 0, B: item.answerRatio?.b ?? 0),
                    editTapAction: {
                        store.send(.view(.presntEditQuestion))
                    }
                )
                
            }
        }
    }
}
