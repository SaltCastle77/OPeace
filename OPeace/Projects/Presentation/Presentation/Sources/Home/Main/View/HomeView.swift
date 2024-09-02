//
//  HomeView.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI
import Combine

import ComposableArchitecture
import SwiftUIIntrospect
import PopupView
import KeychainAccess
import DesignSystem

public struct HomeView: View {
    @Bindable var store: StoreOf<Home>
    
    @State private var refreshTimer: Timer?
    
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
            }
            .task{
                store.send(.async(.fetchQuestionList))
            }
            .onAppear {
                store.send(.async(.fetchQuestionList))
                store.send(.async(.fetchUserProfile))
                startRefreshData()
                appearFloatingPopUp()
            }
            .onDisappear {
                refreshTimer?.invalidate()
            }
            if store.questionModel?.data?.results == []  || ((store.questionModel?.data?.results?.isEmpty) == nil)  {
                
            } else {
                VStack {
                    Spacer()
                    
                    writeQuestionButton()
                        .padding(.bottom, 32)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .sheet(item: $store.scope(state: \.destination?.editQuestion, action: \.destination.editQuestion)) { editQuestionStore in
            EditQuestionView(store: editQuestionStore) {
                guard let edititem =  editQuestionStore.editQuestionitem else {return}
                store.send(.view(.switchModalAction(edititem )))
            } closeModalAction: {
                store.send(.view(.closeEditQuestionModal))
            }
            .presentationDetents([.height(UIScreen.screenHeight * 0.2)])
            .presentationCornerRadius(20)
            .presentationDragIndicator(.hidden)
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
            else if store.isTapBlockUser == true {
                CustomBasicPopUpView(
                    store: customPopUp,
                    title: store.customPopUpText) {
                        store.send(.view(.closePopUp))
                        store.send(.async(.blockUser(qusetionID: store.questionID ?? .zero, userID: store.userID ?? "")))
                    } cancelAction: {
                        store.send(.view(.closePopUp))
                    }
            }
            else if store.isReportQuestionPopUp == true {
                CustomBasicPopUpView(
                    store: customPopUp,
                    title: store.customPopUpText) {
                        store.send(.view(.closePopUp))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            store.send(.navigation(.presntReport))
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
            FloatingPopUpView(store: floatingPopUpStore, title: store.floatingText, image: store.floatingImage)
        }  customize: { popup in
            popup
                .type(.floater(verticalPadding: UIScreen.screenHeight * 0.02))
                .position(.bottom)
                .animation(.spring)
                .closeOnTap(true)
                .closeOnTapOutside(true)
        }
        
    }
    
    private func startRefreshData() {
        refreshTimer?.invalidate()
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            store.send(.async(.fetchQuestionList))
        }
    }
}


extension HomeView {
    
    @ViewBuilder
    private func navigationBaritem() -> some View {
        LazyVStack {
            Spacer()
                .frame(height: 22)
            
            HStack(spacing: .zero) {
                Spacer()
                
                RightImageButton(action: {
                    store.send(.view(.filterViewTappd(.job)))
                }, title: "계열")
                .sheet(item: $store.scope(state: \.destination?.homeFilter, action: \.destination.homeFilter)) { homeFilterStore in
                    HomeFilterView(
                        store: homeFilterStore
                    ) { jobString in
                        store.send(.async(.jobFilterSelected(job: jobString)))
                        store.send(.view(.closeFilterModal))
                    }
                    .presentationDetents([.fraction(0.7)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
                }
                Spacer()
                    .frame(width: 8)
                
                RightImageButton(action: {
                    store.send(.view(.filterViewTappd(.generation)))
                }, title: "세대")
                .sheet(item: $store.scope(state: \.destination?.homeFilter, action: \.destination.homeFilter)) { homeFilterStore in
                    HomeFilterView(
                        store: homeFilterStore
                    ) { generation in
                        store.send(.async(.generationFilterSelected(generation: generation)))
                        store.send(.view(.closeFilterModal))
                    }
                    .presentationDetents([.height(UIScreen.screenHeight * 0.2)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
                }
                Spacer()
                    .frame(width: 8)
                
                RightImageButton(action: {
                    
                }, title: "최신순")
                .sheet(item: $store.scope(state: \.destination?.homeFilter, action: \.destination.homeFilter)) { homeFilterStore in
                    HomeFilterView(
                        store: homeFilterStore
                    ) { jobString in
                        store.send(.async(.filterQuestionList(job: jobString, generation: "", sortBy: .empty)))
                        store.send(.view(.closeFilterModal))
                    }
                    .presentationDetents([.height(UIScreen.screenHeight * 0.2)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
                }
                Spacer()
                    .frame(width: 8)
                
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
                            store.send(.view(.prsentCustomPopUp))
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
        } else if store.isDeleteQuestion == true {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "고민이 삭제되었어요!"
            store.send(.view(.timeToCloseFloatingPopUp))
            store.isDeleteQuestion = false
        } else if store.isReportQuestion == true {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "신고가 완료 되었어요"
            store.floatingImage = .warning
            store.send(.view(.timeToCloseFloatingPopUp))
            store.isReportQuestion = false
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
                    store.send(.view(.prsentCustomPopUp))
                }
                
            }
            .padding(.bottom, 16)
        
    }
    
    @ViewBuilder
    private func questionLIstView() -> some View {
        VStack {
            Spacer()
                .frame(height: 15)
            
            if store.questionModel?.data?.results == []  || ((store.questionModel?.data?.results?.isEmpty) == nil) {
                Spacer()
                    .frame(height: 16)
                
                noQuestionCardView()
                
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
            FlippableCardView(data: resultData) {
                store.send(.async(.fetchQuestionList))
            } onItemAppear: { item in
                if let resultItem = item as? ResultData, resultItem.id != store.questionID {
                    store.questionID = resultItem.id ?? 0
                store.send(.async(.statusQuestion(id: store.questionID ?? .zero)))
                }
            } content: { item in
                CardItemView(
                    resultData: item,
                    statsData: store.statusQuestionModel?.data,
                    isProfile: false,
                    userLoginID: store.profileUserModel?.data?.socialID ?? "",
                    generationColor: store.cardGenerationColor,
                    isTapAVote: $store.isTapAVote,
                    isTapBVote: $store.isTapBVote,
                    isLogOut: store.isLogOut,
                    isLookAround: store.isLookAround,
                    isDeleteUser: store.isDeleteUser,
                    answerRatio: (A: Int(item.answerRatio?.a ?? 0), B: Int(item.answerRatio?.b ?? 0)),
                    editTapAction: {
                        handleEditTap(item: item)
                    },
                    likeTapAction: { userID in
                        handleLikeTap(userID: userID)
                    },
                    appearStatusAction: {
                        appearStatusActionIfNeeded(item: item)
                    },
                    choiceTapAction: {
                        handleChoiceTap(item: item)
                    }
                )
                .onChange(of: store.questionID ?? .zero) { oldValue, newValue in
                    if store.questionID == newValue {
                        store.send(.async(.statusQuestion(id: newValue)))
                    }
                }
            }
        }
    }



    private func handleChoiceTap(item: ResultData) {
        if store.isTapAVote {
            if item.metadata?.voted == true {
                store.send(.async(.statusQuestion(id: item.id ?? .zero)))
            } else if store.profileUserModel?.data?.socialID == item.userInfo?.userID {
                store.questionID = item.id ?? .zero
                store.send(.async(.statusQuestion(id:  store.questionID ?? .zero)))
            } else {
                store.send(.async(.isVoteQuestionAnswer(questionID: item.id ?? .zero, choiceAnswer: store.isSelectAnswerA)))
                store.send(.async(.fetchQuestionList))
            }
        } else if store.isTapBVote {
            if item.metadata?.voted == true {
                store.reportQuestionID = item.id ?? .zero
            } else if store.profileUserModel?.data?.socialID == item.userInfo?.userID {
                store.questionID = item.id ?? .zero
                store.send(.async(.statusQuestion(id:  store.questionID ?? .zero)))
            } else {
                store.send(.async(.isVoteQuestionAnswer(questionID: item.id ?? .zero, choiceAnswer: store.isSelectAnswerB)))
                store.send(.async(.fetchQuestionList))
            }
        } else {
            store.send(.view(.prsentCustomPopUp))
        }
    }
    
    private func handleEditTap(item: ResultData) {
        if store.isLogOut || store.isLookAround || store.isDeleteUser {
            store.send(.view(.prsentCustomPopUp))
        } else {
            store.userID = item.userInfo?.userID ?? ""
            store.reportQuestionID = item.id ?? .zero
            store.questionID = item.id ?? .zero
            store.send(.view(.presntEditQuestion))
        }
    }
    
    private func handleLikeTap(userID: String) {
        if store.isLogOut || store.isLookAround || store.isDeleteUser {
            store.send(.view(.prsentCustomPopUp))
        } else {
            store.send(.async(.isVoteQuestionLike(questioniD: Int(userID) ?? .zero)))
            store.send(.async(.fetchQuestionList))
        }
    }
    
    private func appearStatusActionIfNeeded(item: ResultData) {
        if store.questionID != item.id {
            store.questionID = item.id ?? .zero
            store.send(.async(.statusQuestion(id: store.questionID ?? .zero)))
        }
    }
    
    @ViewBuilder
    private func noQuestionCardView() -> some View {
        VStack {
            Spacer()
            
            Image(asset: .questonSmail)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            
            Spacer()
                .frame(height: 16)
            
            Text("조건에 맞는 고민이 없어요")
                .pretendardFont(family: .SemiBold, size: 24)
                .foregroundStyle(Color.gray200)
            
            Spacer()
                .frame(height: 16)
            
            Text("직접 고민을 등록해보세요")
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray300)
            
            Spacer()
                .frame(height: 32)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.basicWhite)
                .frame(width: 120, height: 56)
                .clipShape(Capsule())
                .overlay {
                    Text("글쓰기")
                        .pretendardFont(family: .Medium, size: 20)
                        .foregroundStyle(Color.textColor100)
                }
                .onTapGesture {
                    if !store.isLogOut && !store.isLookAround && !store.isDeleteUser {
                        store.send(.navigation(.presntWriteQuestion))
                    } else {
                        store.send(.view(.prsentCustomPopUp))
                    }
                }
            
            Spacer()
        }
    }
}
