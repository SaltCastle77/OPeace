//
//  Profile.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI

import ComposableArchitecture

import Utill
import DesignSystem
import Model
import Utills
import UseCase

@Reducer
public struct Profile {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var profileGenerationColor: Color = Color.gray600
        var profileGenerationTextColor: Color = Color.gray600
        var profileGenerationText: String = ""
        var profileUserModel: UpdateUserInfoModel? = nil
        @Presents var destination: Destination.State?
        public init() {}
        
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case setting(Setting)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case tapPresntSettingModal
        case closeModal
    }
    
    
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case fetchUserProfileResponse(Result<UpdateUserInfoModel, CustomError>)
        case fetchUser
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntLogout
        
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .destination(_):
                return .none
                
            case .view(let View):
                switch View {
                    
                case .tapPresntSettingModal:
                    state.destination = .setting(.init())
                    return .none
                    
                case .closeModal:
                    state.destination = nil
                    return .none
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                case .fetchUser:
                    return .run { @MainActor send in
                        let fetchUserData = await Result {
                            try await authUseCase.fetchUserInfo()
                        }
                        
                        switch fetchUserData {
                        case .success(let fetchUserResult):
                            if let fetchUserResult = fetchUserResult {
                                send(.async(.fetchUserProfileResponse(.success(fetchUserResult))))
                            }
                        case .failure(let error):
                            send(.async(.fetchUserProfileResponse(.failure(CustomError.map(error)))))
                            
                        }
                    }
                    
                case .fetchUserProfileResponse(let result):
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
                case .presntLogout:
                    return .none
                }
           
            }
            
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
