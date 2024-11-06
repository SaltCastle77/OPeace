//
//  SignUpPaging.swift
//  Presentation
//
//  Created by 서원지 on 7/24/24.
//

import Foundation
import ComposableArchitecture

import Utill
import DesignSystem
import Networkings

@Reducer
public struct SignUpPaging {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
         var signUpName = SignUpName.State()
         var signUpAge = SignUpAge.State()
        var signUpAges = SignUpAge.State()
        var signUpJob = SignUpJob.State()
        var activeMenu: SignUpTab = .signUpName
        
        var updateUserinfoModel: UpdateUserInfoModel?
        @Presents var destination: Destination.State?
        
        
    }
    
    public enum Action: ViewAction, FeatureAction, BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case signUpName(SignUpName.Action)
        case signUpAge(SignUpAge.Action)
        case signUpJob(SignUpJob.Action)
        case activeTabChanged(SignUpTab)
        
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case customPopUp(CustomPopUp)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case backSelectTab
        case appearPopUp
        case closePopUp
        case presntOnboarding
    }
    
  
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case updateUserInfoResponse(Result<UpdateUserInfoModel, CustomError>)
        case updateUserInfo(
            nickName: String,
            year: Int,
            job: String,
            generation: String)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntOnboarding
        case presntMainHome
    
    }
    
    
    @Dependency(SignUpUseCase.self) var signUpUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
               
            case .destination(_):
                return .none
                
            case .activeTabChanged(let changeTab):
                state.activeMenu = changeTab
                return .none
                
            case .signUpName(.switchSettingTab):
                state.activeMenu = .signUpGeneration
//                state.selectedTab = 1
                return .none
                
            case .signUpAge(.switchTabs):
                state.activeMenu = .signUpJob
//                state.selectedTab = 1
                return .none
                
            case .view(let View):
                switch View {
                    
               
                case .backSelectTab:
                    if state.activeMenu == .signUpGeneration {
                        state.activeMenu = .signUpGeneration
                    } else if state.activeMenu == .signUpGeneration {
                        state.activeMenu = .signUpName
                    }
                    return .none
                    
                case .appearPopUp:
                    state.destination = .customPopUp(.init())
                    return .none
                    
                case .closePopUp:
                    state.destination = nil
                    return .none
                    
                    
                case .presntOnboarding:
                    return .none
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                case .updateUserInfo(let nickname, let year, let job, let generation):
                    return .run {  send in
                        let userInfoResult = await Result {
                            try await signUpUseCase.updateUserInfo(nickname: nickname, year: year, job: job, generation: generation)
                        }
                        
                        switch userInfoResult {
                        case .success(let updateUserInfoData):
                            if let updateUserInfoData = updateUserInfoData {
                                await send(.async(.updateUserInfoResponse(.success(updateUserInfoData))))
                                
                                await  send(.view(.closePopUp))
                             
                                try await clock.sleep(for: .seconds(1))
                                if updateUserInfoData.data?.isFirstLogin == false {
                                    await send(.navigation(.presntOnboarding))
                                } else {
                                    await send(.navigation(.presntMainHome))
                                }
                            }
                            
                        case .failure(let error):
                            await send(.async(.updateUserInfoResponse(.failure(CustomError.map(error)))))
                        }
                    }
                    
                case .updateUserInfoResponse(let result):
                    switch result {
                    case .success(let userInfoData):
                        state.updateUserinfoModel = userInfoData
                    case let .failure(error):
                        Log.error("update user info 리턴 에러", error)
                    }
                    return .none
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
               
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                case .presntOnboarding:
                    return .none
                    
                case .presntMainHome:
                    return .none
                }
                
                
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        Scope(state: \.signUpName, action: \.signUpName) {
            SignUpName()
        }
        Scope(state: \.signUpAge, action: \.signUpAge) {
            SignUpAge()
        }
        Scope(state: \.signUpJob, action: \.signUpJob) {
            SignUpJob()
        }
    }
}
