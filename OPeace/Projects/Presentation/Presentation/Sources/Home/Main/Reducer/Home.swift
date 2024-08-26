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
import KeychainAccess

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
        
        var cardGenerationColor: Color = .basicBlack
        var isLikeTap: Bool = false
        var isRoatinCard: Bool = false
        
        var likedItemId: String?
        var questionID: Int?
        var userID: String?
        var isSelectAnswerA: String = "a"
        var isSelectAnswerB: String = "b"
        var isTapAVote: Bool = false
        var isTapBVote: Bool = false
        
        var profile = Profile.State()
        
        var isTapBlockUser: Bool = false
        var isShowSelectEditModal: Bool = false
        var isBlockQuestionPopUp: Bool = false
        var isReportQuestionPopUp: Bool = false
        
        @Shared var isLogOut: Bool
        @Shared var isDeleteUser: Bool
        @Shared var isLookAround: Bool
        @Shared var isChangeProfile: Bool
        @Shared var isCreateQuestion: Bool
        @Shared var isDeleteQuestion: Bool
        @Shared var isReportQuestion: Bool
        
        @Shared(.inMemory("questionID")) var reportQuestionID: Int = 0
        
        @Presents var destination: Destination.State?
        
       
        public init(
            isLogOut: Bool = false,
            isDeleteUser: Bool = false,
            isLookAround: Bool = false,
            isChangeProfile: Bool = false,
            isCreateQuestion: Bool = false,
            isDeleteQuestion: Bool = false,
            isReportQuestion: Bool = false
        ) {
            self._isLogOut = Shared(wrappedValue: isLogOut, .inMemory("isLogOut"))
            self._isDeleteUser = Shared(wrappedValue: isDeleteUser, .inMemory("isDeleteUser"))
            self._isLookAround = Shared(wrappedValue: isLookAround, .inMemory("isLookAround"))
            self._isChangeProfile = Shared(wrappedValue: isChangeProfile, .inMemory("isChangeProfile"))
            self._isCreateQuestion = Shared(wrappedValue: isCreateQuestion, .inMemory("isCreateQuestion"))
            self._isDeleteQuestion = Shared(wrappedValue: isDeleteQuestion, .inMemory("isDeleteQuestion"))
            self._isReportQuestion = Shared(wrappedValue: isReportQuestion, .inMemory("isReportQuestion"))
        }
        
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case profile(Profile.Action)
        
        
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
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
               
            
            case .view(let View):
                switch View {
                case .appaerProfiluserData:
                    return .run { @MainActor send in
                        send(.profile(.scopeFetchUser))
                    }
                           
                case .prsentCustomPopUp:
                    state.destination = .customPopUp(.init())
                    return .none
                    
                case .closePopUp:
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
                    
                case .presntEditQuestion:
                    state.destination = .editQuestion(.init())
                    return .none
                    
                case .closeEditQuestionModal:
                    state.destination = nil
                    return .none
                    
                case .switchModalAction(let editQuestion):
                    var editQuestion = editQuestion
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
                    
                    return .run { @MainActor send in
                        switch editQuestion {
                        case .reportUser:
                            Log.debug("신고하기")
                            send(.view(.prsentCustomPopUp))
                        case .blockUser:
                            Log.debug("차단하기")
                            send(.view(.prsentCustomPopUp))
                        }
                    }
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                case .fetchQuestionList:
                    var isLikeTap = state.isLikeTap
                    return .run { @MainActor send in
                        let questionResult = await Result {
                            try await questionUseCase.fetchQuestionList(page: 1, pageSize: 20, job: "", generation: "", sortBy: .empty)
                        }
                        
                        switch questionResult {
                        case .success(let questionModel):
                            if let questionModel = questionModel {
                                send(.async(.qusetsionListResponse(.success(questionModel))))
                                
                                
                            }
                        case .failure(let error):
                            send(.async(.qusetsionListResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
                        }
                        
                    }
                    
                case .qusetsionListResponse(let result):
                    switch result {
                    case .success(let qusetsionListData):
                        state.questionModel = qusetsionListData
                    case .failure(let error):
                        Log.error("QuestionList 에어", error.localizedDescription)
                    }
                    
                    return .none
                    
                case .isVoteQuestionLike(questioniD: let questioniD):
                    return .run { @MainActor send in
                        let voteQuestionLikeResult = await Result {
                            try await questionUseCase.isVoteQuestionLike(questionID: questioniD)
                        }
                        
                        switch voteQuestionLikeResult {
                        case .success(let voteQuestionLikeResult):
                            if let voteQuestionLikeResult  = voteQuestionLikeResult {
                                send(.async(.isVoteQuestionLikeResponse(
                                    .success(voteQuestionLikeResult))))
                                
                                send(.async(.fetchQuestionList))
                            }
                        case .failure(let error):
                            send(.async(.isVoteQuestionLikeResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
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
                    return .run { @MainActor send in
                        let blockUserResult = await Result {
                            try await authUseCase.userBlock(questioniD: qusetionID, userID: userID)
                        }
                        switch blockUserResult {
                        case .success(let blockUserResult):
                            if let blockUserResult = blockUserResult {
                                send(.async(.blockUserResponse(.success(blockUserResult))))
                                
                                try await clock.sleep(for: .seconds(0.4))
                                send(.view(.presntFloatintPopUp))
                                
                                send(.view(.timeToCloseFloatingPopUp))
                            }
                        case .failure(let error):
                            send(.async(.blockUserResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
                        }
                    }
                    
                case .blockUserResponse(let result):
                    switch result {
                    case .success(let blockUserResult):
                        state.userBlockModel = blockUserResult
                        state.floatingText = "차단이 완료 되었어요!"
                        state.floatingImage = .warning
                    case .failure(let error):
                        Log.error("유저 차단 에러", error.localizedDescription)
                    }
                    return .none
                    
                case .isVoteQuestionAnswer(let questionID, let choiceAnswer):
                    return .run { @MainActor send in
                        let voteQuestionAnswerResult = await Result {
                            try await questionUseCase.isVoteQuestionAnswer(questionID: questionID, choicAnswer: choiceAnswer)
                        }
                        
                        switch voteQuestionAnswerResult {
                        case .success(let voteQuestionResult):
                            if let voteQuestionResult  = voteQuestionResult {
                                send(.async(.isVoteQuestionAnsweResponse(
                                    .success(voteQuestionResult))))
                                
                            }
                        case .failure(let error):
                            send(.async(.isVoteQuestionAnsweResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
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
                    return .run { @MainActor  send in
                        let fetchUserData = await Result {
                            try await authUseCase.fetchUserInfo()
                        }
                        
                        switch fetchUserData {
                        case .success(let fetchUserResult):
                            if let fetchUserResult = fetchUserResult {
                                send(.async(.userProfileResponse(.success(fetchUserResult))))
                            }
                        case .failure(let error):
                            send(.async(.userProfileResponse(.failure(CustomError.userError(error.localizedDescription)))))
                            
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
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
                    
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                case .presntProfile:
                    return .run { @MainActor send in
                        send(.profile(.scopeFetchUser))
                    }
                    
                case .presntLogin:
                    return .none
                    
                case .presntWriteQuestion:
                    return .none
                    
                case .presntReport:
                    return .none
                }
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        Scope(state: \.profile, action: \.profile) {
            Profile()
        }
    }
}

