//
//  Profile.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI

import ComposableArchitecture
import KeychainAccess

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
        var userLogoutModel: UserLogOut? = nil
        
        var profileGenerationYear: Int? = .zero
        var logoutPopUpTitle: String = "로그아웃 하시겠어요?"
        
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
        case scopeFetchUser
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case setting(Setting)
        case popup(CustomPopUp)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case tapPresntSettingModal
        case closeModal
        case presntPopUp
        case closePopUp
        case updateGenerationInfo
        case switchModalAction(SettingProfile)
        
    }
    
    
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case fetchUserProfileResponse(Result<UpdateUserInfoModel, CustomError>)
        case fetchUser
        case logoutUseResponse(Result<UserLogOut, CustomError>)
        case logoutUser
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntLogout
        case presntEditProfile
        
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .scopeFetchUser:
                return .run { @MainActor send in
                    send(.async(.fetchUser))
                }
                
            case .destination(.presented(.setting(.test))):
                return .none
        
                
                
            case .view(let View):
                switch View {
                    
                case .tapPresntSettingModal:
                    state.destination = .setting(.init())
                    return .run { @MainActor send in
                        send(.destination(.presented(.setting(.test))))
                    }
                    
                case .closeModal:
                    state.destination = nil
                    return .none
                    
                case .presntPopUp:
                    state.destination = .popup(.init())
                    return .none
                    
                case .closePopUp:
                    state.destination = nil
                    return .none
                    
                    
                case .updateGenerationInfo:
                    let (generation, color, textColor) = CheckRegister.getGeneration(
                        year: state.profileGenerationYear ?? .zero,
                        color: state.profileGenerationColor,
                        textColor: state.profileGenerationTextColor
                    )
                    state.profileGenerationText = generation
                    state.profileGenerationColor = color
                    state.profileGenerationTextColor = textColor
                    
                    return .none
                    
                case .switchModalAction(let settingprofile):
                    var settingProfile = settingprofile
                    return .run { send in
                        switch settingProfile {
                        case .editProfile:
                            await send(.navigation(.presntEditProfile))
                        case .blackManagement:
                            Log.debug("회원탈퇴")
                        case .logout:
                            await send(.view(.presntPopUp))
                        case .withDraw:
                            Log.debug("회원탈퇴")
                        }
                        
                    }
                    
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
                                send(.view(.updateGenerationInfo))
                                
                            }
                        case .failure(let error):
                            send(.async(.fetchUserProfileResponse(.failure(CustomError.map(error)))))
                            
                        }
                    }
                    
                case .fetchUserProfileResponse(let result):
                    switch result {
                    case .success(let resultData):
                        state.profileUserModel = resultData
                        state.profileGenerationYear =  state.profileUserModel?.data?.year
                    case let .failure(error):
                        Log.network("프로필 오류", error.localizedDescription)
                    }
                    return .none
                    
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
                                send(.view(.closePopUp))
                                try await self.clock.sleep(for: .seconds(1))
                                
                                
                                send(.navigation(.presntLogout))
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
                case .presntLogout:
                    return .none
                    
                case .presntEditProfile:
                    return .none
                }
           
            default:
                return .none
           
            }
            
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
