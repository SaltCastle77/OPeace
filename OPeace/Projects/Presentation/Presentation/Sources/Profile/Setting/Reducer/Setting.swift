//
//  Setting.swift
//  Presentation
//
//  Created by 서원지 on 8/1/24.
//

import Foundation
import ComposableArchitecture
import KeychainAccess

import Utill
import Model
import UseCase
import Utills

@Reducer
public struct Setting {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var settingtitem: SettingProfile? = nil
        var userLogoutModel: UserLogOut? = nil
        public init() {}
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case tapSettintitem(SettingProfile)
    }
    
    
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case logoutUseResponse(Result<UserLogOut, CustomError>)
        case logoutUser
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        
        
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
                
            case .view(let View):
                switch View {
                case .tapSettintitem(let item):
                    state.settingtitem = item
                    return .none
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                case .logoutUseResponse(let result):
                    switch result{
                    case .success(let userData):
                        state.userLogoutModel = userData
                        Log.debug("유저 로그아웃 성공", userData)
                    case .failure(let error):
                        Log.debug("유저 로그아웃 에러", error.localizedDescription)
                    }
                    return .none
                case .logoutUser:
                    return .run { @MainActor send in
                        let userLogOutData = await Result {
                            try await authUseCase.logoutUser(refreshToken: "")
                        }
                        
                        switch userLogOutData {
                        case .success(let userLogOutData):
                            if let userLogOutData = userLogOutData {
                                send(.async(.logoutUseResponse(.success(userLogOutData))))
                                
                                try Keychain().remove("REFRESH_TOKEN")
                                try await self.clock.sleep(for: .seconds(1))
                            }
                            
                        case .failure(let error):
                            send(.async(.logoutUseResponse(.failure(CustomError.map(error)))))
                        }
                    }
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
             
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                    
                }
            }
        }
    }
}
