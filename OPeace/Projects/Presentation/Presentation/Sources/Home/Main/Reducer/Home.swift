//
//  Home.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture

import Utill
import KeychainAccess
import DesignSystem
import UseCase
import Model

@Reducer
public struct Home {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        var profileImage: String = "person.fill"
        var loginTiltle: String = "로그인을 해야 다른 기능을 사용하실 수 있습니다. "
        var floatingText: String = ""
        
        var questionModel: QuestionModel? = nil
        var cardGenerationColor: Color = .basicBlack
        
        var profile = Profile.State()
        
        @Shared var isLogOut: Bool
        @Shared var isDeleteUser: Bool
        @Shared var isLookAround: Bool
        @Shared var isChangeProfile: Bool
        @Shared var isCreateQuestion: Bool
        
        @Presents var destination: Destination.State?
        
       
        
        public init(
            isLogOut: Bool = false,
            isDeleteUser: Bool = false,
            isLookAround: Bool = false,
            isChangeProfile: Bool = false,
            isCreateQuestion: Bool = false
        ) {
            self._isLogOut = Shared(wrappedValue: isLogOut, .inMemory("isLogOut"))
            self._isDeleteUser = Shared(wrappedValue: isDeleteUser, .inMemory("isDeleteUser"))
            self._isLookAround = Shared(wrappedValue: isLookAround, .inMemory("isLookAround"))
            self._isChangeProfile = Shared(wrappedValue: isChangeProfile, .inMemory("isChangeProfile"))
            self._isCreateQuestion = Shared(wrappedValue: isCreateQuestion, .inMemory("isCreateQuestion"))
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
//    @CasePathable
    public enum View {
        case appaerProfiluserData
        case prsentLoginPopUp
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
        
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntProfile
        case presntLogin
        case presntWriteQuestion
    
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(QuestionUseCase.self) var questionUseCase
    
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
                           
                case .prsentLoginPopUp:
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
                    return .run { send in
                        switch editQuestion {
                        case .reportUser:
                            Log.debug("신고하기")
                        case .blockUser:
                            Log.debug("차단하기")
                        }
                    }
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                case .fetchQuestionList:
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

