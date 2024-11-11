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
            .onAppear {
              store.send(.async(.appearData))
                startRefreshData()
                appearFloatingPopUp()
            }
            .onDisappear {
                store.send(.async(.clearFilter))
                refreshTimer?.invalidate()
            }
            if store.questionModel?.data?.results == []  ||
                ((store.questionModel?.data?.results?.isEmpty) == nil)  {
                
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
        
        .sheet(item: $store.scope(state: \.destination?.homeFilter, action: \.destination.homeFilter)) { homeFilterStore in
            HomeFilterView(
                store: homeFilterStore,
                           selectItem: $store.selectedItem,
                           closeModalAction: { data in
                guard let homeFilter = homeFilterStore.homeFilterTypeState else { return }
                store.isFilterQuestion = true
                               
                switch homeFilter {
                    case .job:
                        store.send(.async(.jobFilterSelected(job: data)))
                        store.send(.view(.closeFilterModal))
                    case .generation:
                        store.send(.async(.generationFilterSelected(generation:data)))
                        store.send(.view(.closeFilterModal))
                    case .sorted(let sortedEnum):
                        let sortedEnumFromData = QuestionSort.fromKoreanString(data)
                        store.send(.async(.sortedFilterSelected(sortedEnum: sortedEnumFromData)))
                        store.send(.view(.closeFilterModal))
                }
                
            })
            .presentationDetents([.fraction(homeFilterStore.homeFilterTypeState == .job ? 0.7 : homeFilterStore.homeFilterTypeState == .generation ? 0.42: 0.2 )])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(20)
        }
        
        .popup(item: $store.scope(state: \.destination?.customPopUp, action: \.destination.customPopUp)) { customPopUp in
            if store.userInfoModel?.isLogOut == true || store.userInfoModel?.isLookAround == true || store.userInfoModel?.isDeleteUser == true {
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
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        store.send(.async(.blockUser(qusetionID: store.questionID ?? .zero, userID: store.userID ?? "")))
                      
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                          store.send(.async(.appearData))
                        }
                      }
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
        
        if !store.isFilterQuestion {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
                store.send(.async(.fetchQuestionList))
            }
        }
    }
}


extension HomeView {
    
    @ViewBuilder
    private func navigationBaritem() -> some View {
        LazyVStack {
            Spacer()
                .frame(height: 22)
            
            HStack(spacing: 8) {
                Spacer()
                
                RightImageButton(isActive: $store.isActivateJobButton, action: {
                    store.send(.view(.filterViewTappd(.job)))
                }, title: store.selectedJobButtonTitle)
                .frame(maxHeight: .infinity)
                
                RightImageButton(isActive: $store.isActivateGenerationButton, action: {
                    store.send(.view(.filterViewTappd(.generation)))
                }, title: store.selectedGenerationButtonTitle)
                .frame(maxHeight: .infinity)
                
                RightImageButton(isActive: $store.isActivateSortedButton, action: {
                    store.send(.view(.filterViewTappd(.sorted(.popular))))
                }, title: store.selectedSortedButtonTitle.sortedKoreanString)
                .frame(maxHeight: .infinity)
                                
                if store.userInfoModel?.isLogOut == true ||
                    store.userInfoModel?.isLookAround == true ||
                    store.userInfoModel?.isDeleteUser == true {
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
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
    }
    
    private func appearFloatingPopUp() {
        if store.userInfoModel?.isLogOut == true  {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "로그아웃 되었어요"
            store.send(.view(.timeToCloseFloatingPopUp))
        } else if store.userInfoModel?.isLookAround == true {
            store.floatingText = "로그인 하시겠어요?"
        } else if store.userInfoModel?.isDeleteUser == true  {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "탈퇴 완료! 언젠가 다시 만나요"
            store.send(.view(.timeToCloseFloatingPopUp))
        } else if store.userInfoModel?.isChangeProfile == true {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "수정이 완료되었어요!"
            store.send(.view(.timeToCloseFloatingPopUp))
            store.userInfoModel?.isChangeProfile = false
        } else if store.userInfoModel?.isCreateQuestion == true {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "고민 등록이 완료 되었어요!"
            store.send(.view(.timeToCloseFloatingPopUp))
            store.userInfoModel?.isCreateQuestion = false
        } else if store.userInfoModel?.isDeleteQuestion == true {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "고민이 삭제되었어요!"
            store.send(.view(.timeToCloseFloatingPopUp))
            store.userInfoModel?.isDeleteQuestion = false
        } else if store.userInfoModel?.isReportQuestion == true {
            store.send(.view(.presntFloatintPopUp))
            store.floatingText = "신고가 완료 되었어요"
            store.floatingImage = .warning
            store.send(.view(.timeToCloseFloatingPopUp))
            store.userInfoModel?.isReportQuestion = false
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
                if store.userInfoModel?.isLogOut == false &&
                store.userInfoModel?.isLookAround == false &&
                store.userInfoModel?.isDeleteUser == false {
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
    if store.userInfoModel?.isLogOut == true {
      noFilterQuestionList()
    } else {
      filterQuestionList()
    }
  }
  
  @ViewBuilder
  private func filterQuestionList() -> some View {
    if let resultData = store.questionModel?.data?.results?.filter({ item in
      let blockedNicknames = store.userBlockListModel?.data.compactMap { $0.nickname } ?? []
        guard let nickname = item.userInfo?.userNickname else { return true }
        return !blockedNicknames.contains(nickname)
    }) {
        FlippableCardView(
            data: resultData,
            shouldSaveState: true
        ) {
            if !store.isFilterQuestion {
                store.send(.async(.fetchQuestionList))
            }
        } onItemAppear: { item in
            if let resultItem = item as? ResultData, resultItem.id != store.questionID {
                store.questionID = resultItem.id ?? 0
            }
        } content: { item in
            CardItemView(
                resultData: item,
                statsData: store.statusQuestionModel?.data,
                isProfile: false,
                userLoginID: store.profileUserModel?.data.socialID ?? "",
                generationColor: store.cardGenerationColor,
                isTapAVote: $store.isTapAVote,
                isTapBVote: $store.isTapBVote,
                isLogOut: store.userInfoModel?.isLogOut ?? false,
                isLookAround: store.userInfoModel?.isLookAround ?? false,
                isDeleteUser: store.userInfoModel?.isDeleteUser ?? false,
                answerRatio: (A: Int(item.answerRatio?.a ?? 0), B: Int(item.answerRatio?.b ?? 0)),
                editTapAction: {
                    handleEditTap(item: item)
                },
                likeTapAction: { userID in
                    handleLikeTap(userID: userID)
                },
                appearStatusAction: {
                },
                choiceTapAction: {
                    handleChoiceTap(item: item)
                }
            )
            .onChange(of: store.questionID ?? .zero) { oldValue, newValue in
                guard let id = item.id, id == newValue else { return }
                store.send(.async(.statusQuestion(id: newValue)))
            }
        }
    }
  }
  
  @ViewBuilder
  private func noFilterQuestionList() -> some View {
    if let resultData = store.questionModel?.data?.results {
          FlippableCardView(
              data: resultData,
              shouldSaveState: true) {
              if !store.isFilterQuestion {
                  store.send(.async(.fetchQuestionList))
              }
          } onItemAppear: { item in
              if let resultItem = item as? ResultData, resultItem.id != store.questionID {
                  store.questionID = resultItem.id ?? 0
              }
          } content: { item in
              CardItemView(
                  resultData: item,
                  statsData: store.statusQuestionModel?.data,
                  isProfile: false,
                  userLoginID: store.profileUserModel?.data.socialID ?? "",
                  generationColor: store.cardGenerationColor,
                  isTapAVote: $store.isTapAVote,
                  isTapBVote: $store.isTapBVote,
                  isLogOut: store.userInfoModel?.isLogOut ?? false,
                  isLookAround: store.userInfoModel?.isLookAround ?? false,
                  isDeleteUser: store.userInfoModel?.isDeleteUser ?? false,
                  answerRatio: (A: Int(item.answerRatio?.a ?? 0), B: Int(item.answerRatio?.b ?? 0)),
                  editTapAction: {
                      handleEditTap(item: item)
                  },
                  likeTapAction: { userID in
                      handleLikeTap(userID: userID)
                  },
                  appearStatusAction: {

                  },
                  choiceTapAction: {
                      handleChoiceTap(item: item)
                  }
              )
//                .onAppear {
//                    store.send(.async(.statusQuestion(id: item.id ?? .zero)))
//                }
              
              .onChange(of: store.questionID ?? .zero) { oldValue, newValue in
                  guard let id = item.id, id == newValue else { return }
                  store.send(.async(.statusQuestion(id: newValue)))
              }
          }
      }
  }



    private func handleChoiceTap(item: ResultData) {
        if store.isTapAVote {
            if item.metadata?.voted == true {
                store.questionID = item.id ?? .zero
                store.send(.async(.statusQuestion(id: item.id ?? .zero)))
            } else if store.profileUserModel?.data.socialID == item.userInfo?.userID {
                store.questionID = item.id ?? .zero
                store.isTapAVote = false
            } else if store.profileUserModel?.data.socialID != item.userInfo?.userID {
                store.send(.async(.isVoteQuestionAnswer(questionID: item.id ?? .zero, choiceAnswer: store.isSelectAnswerA)))
                store.send(.async(.fetchQuestionList))
                store.questionID = item.id ?? .zero
                store.send(.async(.statusQuestion(id: item.id ?? .zero)))
            }
        } else if store.isTapBVote {
            if item.metadata?.voted == true {
                store.questionID = item.id ?? .zero
                store.send(.async(.statusQuestion(id: store.questionID ?? .zero)))
            } else if store.profileUserModel?.data.socialID == item.userInfo?.userID {
                store.questionID = item.id ?? .zero
                store.isTapBVote = false
            } else if store.profileUserModel?.data.socialID != item.userInfo?.userID{
                store.send(.async(.isVoteQuestionAnswer(questionID: item.id ?? .zero, choiceAnswer: store.isSelectAnswerB)))
                store.send(.async(.fetchQuestionList))
                store.questionID = item.id ?? .zero
                store.send(.async(.statusQuestion(id: item.id ?? .zero)))
            }
        } else {
            store.send(.view(.prsentCustomPopUp))
        }
    }
    
    private func handleEditTap(item: ResultData) {
        if store.userInfoModel?.isLogOut == true ||
            store.userInfoModel?.isLookAround == true ||
            store.userInfoModel?.isDeleteUser == true {
            store.send(.view(.prsentCustomPopUp))
        } else {
            store.userID = item.userInfo?.userID ?? ""
            store.reportQuestionID = item.id ?? .zero
            store.questionID = item.id ?? .zero
            store.send(.view(.presntEditQuestion))
        }
    }
    
    private func handleLikeTap(userID: String) {
        if store.userInfoModel?.isLogOut == true ||
            store.userInfoModel?.isLookAround == true ||
            store.userInfoModel?.isDeleteUser == true {
            store.send(.view(.prsentCustomPopUp))
        } else {
            store.send(.async(.isVoteQuestionLike(questioniD: Int(userID) ?? .zero)))
            store.send(.async(.fetchQuestionList))
        }
    }
    
    private func appearStatusActionIfNeeded(item: ResultData) {
        if store.questionID != item.id {
            store.questionID = item.id ?? .zero
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
                    if store.userInfoModel?.isLogOut == false &&
                    store.userInfoModel?.isLookAround == false &&
                    store.userInfoModel?.isDeleteUser == false {
                        store.send(.navigation(.presntWriteQuestion))
                    } else {
                        store.send(.view(.prsentCustomPopUp))
                    }
                }
            
            Spacer()
        }
    }
}
