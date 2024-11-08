//
//  Home.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import Foundation
import SwiftUI
import Combine

import ComposableArchitecture
import Networkings

@Reducer
public struct Home {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        var profileImage: String = "person.fill"
        var loginTiltle: String = "로그인을 해야 다른 기능을 사용하실 수 있습니다. "
        var floatingText: String = ""
        var customPopUpText: String = ""
        var floatingImage: ImageAsset = .succesLogout
        var cancellable: AnyCancellable?
        
        var questionModel: QuestionModel? = nil
        var isVoteLikeQuestionModel: VoteQuestionLikeModel? = nil
        var userBlockModel: UserBlockModel? = nil
        var isVoteAnswerQuestionModel: QuestionVoteModel? = nil
        var profileUserModel: UpdateUserInfoModel? = nil
        var statusQuestionModel: StatusQuestionModel? = nil
        var userBlockListModel: UserBlockListModel?  = nil
        
        var cardGenerationColor: Color = .basicBlack
        var isLikeTap: Bool = false
        var isRoatinCard: Bool = false
        
        var likedItemId: String?
        var questionID: Int?
        var userID: String?
        var isSelectAnswerA: String = "a"
        var isSelectAnswerB: String = "b"
        var questionDetailId: Int? = nil
        var isTapAVote: Bool = false
        var isTapBVote: Bool = false
        
//        var profile = Profile.State()
        var pageSize: Int  = 20
        
        var isTapBlockUser: Bool = false
        var isShowSelectEditModal: Bool = false
        var isBlockQuestionPopUp: Bool = false
        var isReportQuestionPopUp: Bool = false
        
        var selectedJobButtonTitle: String = "계열"
        var selectedJob: String = ""
        var isActivateJobButton: Bool = false
        
        var selectedGenerationButtonTitle: String = "세대"
        var selectedGeneration: String = ""
        var isActivateGenerationButton: Bool = false
        
        var selectedSortedButtonTitle: QuestionSort = .recent
        var selectedSorted: QuestionSort = .recent
        var isActivateSortedButton: Bool = true
        
        var selectedSortDesc: String = ""
        var isFilterQuestion: Bool = false
        var selectedItem: String? = ""
        
        @Shared var userInfoModel: UserInfoModel?
        
        @Shared(.inMemory("questionID")) var reportQuestionID: Int = 0
        
        @Presents var destination: Destination.State?
        
       
        public init(

            userInfoModel: UserInfoModel? = .init()
        ) {
            self._userInfoModel = Shared(wrappedValue: userInfoModel, .inMemory("userInfoModel"))
        }
        
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
//        case profile(Profile.Action)
        
        
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case homeFilter(HomeFilter)
        case customPopUp(CustomPopUp)
        case floatingPopUP(FloatingPopUp)
        case editQuestion(EditQuestion)
        
    }
    
    //MARK: - ViewAction
    public enum View {
        case appaerProfiluserData
        case prsentCustomPopUp
        case presntFloatintPopUp
        case presntEditQuestion
        case closeEditQuestionModal
        case closePopUp
        case timeToCloseFloatingPopUp
        case switchModalAction(EditQuestionType)
        case filterViewTappd(HomeFilterEnum)
        case closeFilterModal
    }
    
  
    
  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case fetchQuestionList
    case qusetsionListResponse(Result<QuestionModel, CustomError>)
    case isVoteQuestionLike(questioniD: Int)
    case isVoteQuestionLikeResponse(Result<VoteQuestionLikeModel, CustomError>)
    case blockUser(qusetionID: Int, userID: String)
    case blockUserResponse(Result<UserBlockModel, CustomError>)
    case isVoteQuestionAnswer(questionID: Int, choiceAnswer: String)
    case isVoteQuestionAnsweResponse(Result<QuestionVoteModel, CustomError>)
    case fetchUserProfile
    case userProfileResponse(Result<UpdateUserInfoModel, CustomError>)
    case jobFilterSelected(job: String)
    case generationFilterSelected(generation: String)
    case sortedFilterSelected(sortedEnum:QuestionSort)
    case filterQuestionList(job: String , generation: String, sortBy: QuestionSort)
    case statusQuestion(id: Int)
    case statusQuestionResponse(Result<StatusQuestionModel, CustomError>)
    case clearFilter
    case fetchUserBlockList
    case fetchUserBlockResponse(Result<UserBlockListModel, CustomError>)
    case appearData
    
  }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntProfile
        case presntLogin
        case presntWriteQuestion
        case presntReport
    
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(QuestionUseCase.self) var questionUseCase
    @Dependency(AuthUseCase.self) var authUseCase
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .destination(.presented(.homeFilter(.test))):
                return .none
                
            case .binding(\.questionID):
                return .none
                
            case .view(let View):
              return handleViewAction(state: &state, action: View)
                
            case .async(let AsyncAction):
              return handleAsyncAction(state: &state, action: AsyncAction)
                
            case .inner(let InnerAction):
              return handleInnerAction(state: &state, action: InnerAction)
                
            case .navigation(let NavigationAction):
              return handleNavigationAction(state: &state, action: NavigationAction)
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .onChange(of: \.questionModel) { oldValue, newValue in
            Reduce { state, action in
                state.questionModel = newValue
                return .none
            }
        }
        .onChange(of: \.statusQuestionModel) { oldValue, newValue in
            Reduce { state, action in
                state.statusQuestionModel = newValue
                return .none
            }
        }
        .onChange(of: \.userInfoModel) { oldValue, newValue in
            Reduce { state, action in
                state.userInfoModel = newValue
                return .none
            }
        }
    }
  
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
    case .appaerProfiluserData:
        return .run { send in
//                        await send(.profile(.scopeFetchUser))
        }
               
    case .prsentCustomPopUp:
        state.destination = .customPopUp(.init())
        return .none
        
    case .closePopUp:
        state.destination = nil
        return .none
    case .closeFilterModal:
        state.destination = nil
        return .none

    case .presntFloatintPopUp:
        state.destination = .floatingPopUP(.init())
        return .none
        
    case .timeToCloseFloatingPopUp:
        return .run { send in
            try await clock.sleep(for: .seconds(1.5))
            await send(.view(.closePopUp))
        }
    case .filterViewTappd(let filterEnum):
        state.destination = .homeFilter(.init(homeFilterEnum: filterEnum))
        switch filterEnum {
        case .job:
            state.selectedItem = state.selectedJob
        case .generation:
            state.selectedItem = state.selectedGeneration
        case .sorted(let sortedOrderEnum):
            state.selectedItem = state.selectedSorted.sortedKoreanString
        }
        return .run {  send in
            await send(.destination(.presented(.homeFilter(.async(.fetchListByFilterEnum(filterEnum))))))
        }
    
    case .presntEditQuestion:
        state.destination = .editQuestion(.init())
        return .none
        
    case .closeEditQuestionModal:
        state.destination = nil
        return .none
        
    case .switchModalAction(let editQuestion):
        nonisolated(unsafe) let editQuestion = editQuestion
        switch editQuestion {
        case .reportUser:
            Log.debug("신고하기")
            state.customPopUpText = "정말 신고하시겠어요?"
            state.isReportQuestionPopUp = true
        case .blockUser:
            Log.debug("차단하기")
            state.customPopUpText = "정말 차단하시겠어요?"
            state.isTapBlockUser = true
        }
        
        return .run {  send in
            switch editQuestion {
            case .reportUser:
                Log.debug("신고하기")
              await send(.view(.prsentCustomPopUp))
            case .blockUser:
                Log.debug("차단하기")
              await send(.view(.prsentCustomPopUp))
            }
        }
    }
  }
  
  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
    case .presntProfile:
        return .run {  send in
//                        await send(.profile(.scopeFetchUser))
        }
        
    case .presntLogin:
        return .none
        
    case .presntWriteQuestion:
        return .none
        
    case .presntReport:
        return .none
    }
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchQuestionList:
        let pageSize = state.pageSize
        return .run {  send in
            let questionResult = await Result {
                try await questionUseCase.fetchQuestionList(
                    page: 1,
                    pageSize: pageSize,
                    job: "",
                    generation: "",
                    sortBy: .empty)
            }
            
            switch questionResult {
            case .success(let questionModel):
                if let questionModel = questionModel {
                    await send(.async(.qusetsionListResponse(.success(questionModel))))
                }
            case .failure(let error):
                await send(.async(.qusetsionListResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
            }
            
        }
        
    case .jobFilterSelected(let job):
        let currentSelectedGeneration = state.selectedGeneration
        nonisolated(unsafe) let currentSortBy = state.selectedSorted
        if state.selectedJob == job {
            state.selectedJobButtonTitle = "계열"
            state.selectedJob = ""
            state.selectedItem = ""
            state.isActivateJobButton = false
          
            return .send(.async(.filterQuestionList(job: "", generation: currentSelectedGeneration, sortBy: currentSortBy)))
        } else {
            state.selectedJobButtonTitle = job
            state.selectedJob = job
            state.selectedItem = ""
            state.isActivateJobButton = true
            return .send(.async(.filterQuestionList(job: job, generation: currentSelectedGeneration, sortBy: currentSortBy)))
        }
    case .generationFilterSelected(let generation):
        let currentSelectedJob = state.selectedJob
        nonisolated(unsafe) let currentSortBy = state.selectedSorted
        if state.selectedGeneration == generation {
            state.selectedGenerationButtonTitle = "세대"
            state.selectedGeneration = ""
            state.selectedItem = ""
            state.isActivateGenerationButton = false
            return .send(.async(.filterQuestionList(job: currentSelectedJob, generation: "", sortBy: currentSortBy)))
        } else {
            state.isActivateGenerationButton = true
            state.selectedGenerationButtonTitle = generation
            state.selectedItem = generation
            state.selectedGeneration = generation
            return .send(.async(.filterQuestionList(job: currentSelectedJob, generation: generation, sortBy: currentSortBy)))
        }
    case .sortedFilterSelected(let sorted):
        let currentSelectedGeneration = state.selectedGeneration
        let currentSelectedJob = state.selectedJob

        
        if state.selectedSorted == sorted {
            state.selectedSorted = .empty
            return .send(.async(.filterQuestionList(job: currentSelectedJob, generation: currentSelectedGeneration, sortBy: .empty)))
        } else {
            state.selectedSorted = sorted
            state.selectedSortedButtonTitle = sorted
            return .send(.async(.filterQuestionList(job: currentSelectedJob, generation: currentSelectedGeneration, sortBy: sorted)))
        }
        
    case .filterQuestionList(let job, let generation, let sortBy):
        let pageSize = state.pageSize
         
        return .run {  send in
            let questionResult = await Result {
                try await questionUseCase.fetchQuestionList(
                    page: 1,
                    pageSize: pageSize,
                    job: job,
                    generation: generation,
                    sortBy: sortBy)
            }
            
            switch questionResult {
            case .success(let questionModel):
                if let questionModel = questionModel {
                    await send(.async(.qusetsionListResponse(.success(questionModel))))
                }
            case .failure(let error):
                await  send(.async(.qusetsionListResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
            }
        }
        
    case .clearFilter:
        state.selectedJobButtonTitle = "계열"
        state.selectedJob = ""
        state.selectedItem = ""
        state.isActivateJobButton = false
        state.selectedGenerationButtonTitle = "세대"
        state.selectedGeneration = ""
        state.isActivateGenerationButton = false
        state.selectedSorted = .recent
        return .none
        
    case .qusetsionListResponse(let result):
        switch result {
        case .success(let qusetsionListData):
            // userInfoModel.isLogOut 확인
            if state.userInfoModel?.isLogOut == true {
                // 로그아웃 상태에서는 필터링하지 않고 원래 데이터를 그대로 사용
                state.questionModel = qusetsionListData
            } else {
                // 차단된 닉네임 리스트 가져오기
                let blockedNicknames = state.userBlockListModel?.data?.compactMap { $0.nickname } ?? []
                
                // 차단된 닉네임 제외한 결과 필터링
                let filteredResults = qusetsionListData.data?.results?.filter { item in
                    guard let nickname = item.userInfo?.userNickname else { return true }
                    return !blockedNicknames.contains(nickname)
                }
                
                // 새로운 데이터를 생성하여 필터링된 결과를 저장
                var updatedQuestionListData = qusetsionListData
                updatedQuestionListData.data = updatedQuestionListData.data.map { data in
                    var modifiedData = data
                    modifiedData.results = filteredResults
                    return modifiedData
                }
                
                state.questionModel = updatedQuestionListData
            }
            
            // 페이지 크기 증가
            state.pageSize += 20
        case .failure(let error):
            Log.error("QuestionList 에러", error.localizedDescription)
        }
        return .none
        
    case .isVoteQuestionLike(questioniD: let questioniD):
        return .run { send in
            let voteQuestionLikeResult = await Result {
                try await questionUseCase.isVoteQuestionLike(questionID: questioniD)
            }
            
            switch voteQuestionLikeResult {
            case .success(let voteQuestionLikeResult):
                if let voteQuestionLikeResult  = voteQuestionLikeResult {
                    await  send(.async(.isVoteQuestionLikeResponse(
                        .success(voteQuestionLikeResult))))
                    
                    await send(.async(.fetchQuestionList))
                }
            case .failure(let error):
                await send(.async(.isVoteQuestionLikeResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
            }
        }
        
    case .isVoteQuestionLikeResponse(let voteQuestionResult):
        switch voteQuestionResult {
        case .success(let voteQuestionResult):
            state.isVoteLikeQuestionModel = voteQuestionResult
            state.isLikeTap.toggle()
        case .failure(let error):
            Log.error("좋아요 누르기 에러", error.localizedDescription)
        }
        return .none
        
    case .blockUser(let qusetionID, let userID):
        return .run { send in
            let blockUserResult = await Result {
                try await authUseCase.userBlock(questioniD: qusetionID, userID: userID)
            }
            switch blockUserResult {
            case .success(let blockUserResult):
                if let blockUserResult = blockUserResult {
                    await  send(.async(.blockUserResponse(.success(blockUserResult))))
                    
                    try await clock.sleep(for: .seconds(0.4))
                    await  send(.view(.presntFloatintPopUp))
                    
                    await send(.view(.timeToCloseFloatingPopUp))
                }
            case .failure(let error):
                await  send(.async(.blockUserResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
            }
        }
        
    case .blockUserResponse(let result):
        switch result {
        case .success(let blockUserResult):
            state.userBlockModel = blockUserResult
            state.floatingText = "차단이 완료 되었어요!"
            state.floatingImage = .succesLogout
        case .failure(let error):
            Log.error("유저 차단 에러", error.localizedDescription)
        }
        return .none
        
    case .isVoteQuestionAnswer(let questionID, let choiceAnswer):
        return .run { send in
            let voteQuestionAnswerResult = await Result {
                try await questionUseCase.isVoteQuestionAnswer(questionID: questionID, choicAnswer: choiceAnswer)
            }
            
            switch voteQuestionAnswerResult {
            case .success(let voteQuestionResult):
                if let voteQuestionResult  = voteQuestionResult {
                    await send(.async(.isVoteQuestionAnsweResponse(
                        .success(voteQuestionResult))))
                    
                }
            case .failure(let error):
                await send(.async(.isVoteQuestionAnsweResponse(.failure(
                    CustomError.createQuestionError(error.localizedDescription)))))
            }
        }
        
    case .isVoteQuestionAnsweResponse(let reuslt):
        switch reuslt {
        case .success(let isVoteQuestionAnswer):
            state.isVoteAnswerQuestionModel = isVoteQuestionAnswer
            state.isRoatinCard = true
        case .failure(let error):
            Log.error("유저 투표 에러", error.localizedDescription)
        }
        return .none
        
        
    case .fetchUserProfile:
        return .run {  send in
            let fetchUserData = await Result {
                try await authUseCase.fetchUserInfo()
            }
            
            switch fetchUserData {
            case .success(let fetchUserResult):
                if let fetchUserResult = fetchUserResult {
                    await send(.async(.userProfileResponse(.success(fetchUserResult))))
                }
            case .failure(let error):
                await send(.async(.userProfileResponse(.failure(
                    CustomError.userError(error.localizedDescription)))))
                
            }
        }
        
    case .userProfileResponse(let result):
        switch result {
        case .success(let resultData):
            state.profileUserModel = resultData
        case let .failure(error):
            Log.network("프로필 오류", error.localizedDescription)
        }
        return .none
        
    case .statusQuestion(id: let id):
        return .run { send in
            let questionResult = await Result {
                try await questionUseCase.statusQuestion(questionID: id)
            }
            
            switch questionResult {
            case .success(let questionStatusData):
            if let questionStatusData = questionStatusData {
                    await send(.async(.statusQuestionResponse(.success(questionStatusData))))
                }
            case .failure(let error):
                await send(.async(.statusQuestionResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
            }
        }
        
    case .statusQuestionResponse(let result):
        switch result {
        case .success(let statusQuestionData):
            state.statusQuestionModel = statusQuestionData
        case .failure(let error):
            Log.error("질문 에대한 결과 보여주기 실패", error.localizedDescription)
        }
        return .none
      
    case .fetchUserBlockList:
        return .run {  send in
            let userBlockResult = await Result {
                try await authUseCase.fetchUserBlockList()
            }
            
            switch userBlockResult {
            case .success(let userBlockLIstData):
                if let userBlockListData = userBlockLIstData {
                  await send(.async(.fetchUserBlockResponse(.success(userBlockListData))))
                }
                
            case .failure(let error):
              await send(.async(.fetchUserBlockResponse(.failure(CustomError.userError(error.localizedDescription)))))
            }
        }
        
    case .fetchUserBlockResponse(let result):
        switch result {
        case .success(let userBlockListData):
            state.userBlockListModel = userBlockListData
        case .failure(let error):
            Log.error("차단 유저 가져오기 실패", error.localizedDescription)
        }
        return .none
      
    case .appearData:
      return .concatenate(
        Effect.run(operation: { send in
          await send (.async(.fetchQuestionList))
        }),
        Effect.run(operation: { send in
          await send (.async(.fetchUserProfile))
        }),
        Effect.run(operation: { [userInfoModel = state.userInfoModel] send in
          await send(.async(.fetchUserBlockList))
        })
        
      )
    }
  }
  
  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
   
    }
  }
  
}

