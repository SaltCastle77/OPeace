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

import KakaoSDKAuth
import KakaoSDKUser

@Reducer
public struct Profile {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var profileGenerationColor: Color = Color.gray600
        var profileGenerationTextColor: Color = Color.gray600
        var profileGenerationText: String = ""
        
        var profileUserModel: UpdateUserInfoModel? = nil
        var userLogoutModel: UserLogOutModel? = nil
        var userDeleteModel: DeleteUserModel? = nil
        var myQuestionListModel: QuestionModel?  = nil
        var deleteQuestionModel: DeleteQuestionModel? = nil
        
        var profileGenerationYear: Int? = .zero
        var logoutPopUpTitle: String = "로그아웃 하시겠어요?"
        var deletePopUpTitle: String = "정말 탈퇴하시겠어요?"
        var isLogOutPopUp: Bool = false
        var isDeleteUserPopUp: Bool = false
        var isDeleteQuestionPopUp: Bool = false
        var popUpText: String = ""
        
        var cardGenerationColor: Color = .basicBlack
        var deleteQuestionId: Int = .zero
        
        @Presents var destination: Destination.State?
        @Shared(.inMemory("isLogOut")) var isLogOut: Bool = false
        @Shared(.inMemory("isDeleteUser")) var isDeleteUser: Bool = false
        @Shared(.inMemory("isChangeProfile")) var isChangeProfile: Bool = false
        @Shared(.inMemory("isDeleteQuestion")) var isDeleteQuestion: Bool = false
        @Shared(.inMemory("loginSocialType")) var loginSocialType: SocialType? = nil
        
        public init() {}
    }
    
    public indirect enum Action: ViewAction, BindableAction, FeatureAction {
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
        case home(Home)
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
        case logoutUseResponse(Result<UserLogOutModel, CustomError>)
        case logoutUser
        case socilalLogOutUser
        case fetchQuestionResponse(Result<QuestionModel, CustomError>)
        case fetchQuestion
        case deleteQuestion(questionID: Int)
        case deleteQuestionResponse(Result<DeleteQuestionModel, CustomError>)
        
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntLogout
        case presntEditProfile
        case presntWithDraw
        case presnetCreateQuestionList
        case presntDeleteQuestion
        case presntUserBlock
        
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    @Dependency(QuestionUseCase.self) var questionUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .scopeFetchUser:
                state.isChangeProfile = false
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
                    switch settingProfile {
                    case .editProfile:
                        Log.debug("프로필 수정")
                    case .blackManagement:
                        Log.debug("차단")
                    case .logout:
                        state.popUpText = "로그아웃 하시겠어요?"
                        state.isLogOutPopUp = true
                    case .withDraw:
                        state.popUpText = "정말 탈퇴하시겠어요?"
                        state.isDeleteUserPopUp = true
                    }
                    return .run { send in
                        switch settingProfile {
                        case .editProfile:
                            await send(.navigation(.presntEditProfile))
                        case .blackManagement:
                            Log.debug("차단")
                            await send(.navigation(.presntUserBlock))
                        case .logout:
                            await send(.view(.presntPopUp))
                        case .withDraw:
                            await send(.view(.presntPopUp))
                        }
                        
                    }
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                case .fetchUser:
                    return .run { @MainActor  send in
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
                        state.isChangeProfile = false
                    case let .failure(error):
                        Log.network("프로필 오류", error.localizedDescription)
                    }
                    return .none
                    
                case .socilalLogOutUser:
                    var loginSocialType = state.loginSocialType
                    return .run { @MainActor send in
                        switch loginSocialType {
                        case .kakao:
                            UserApi.shared.logout { error in
                                if let error = error {
                                    Log.debug("카카오 로그아웃 오류", error.localizedDescription)
                                } else {
                                    Task {
                                        try await self.clock.sleep(for: .seconds(1))
                                         send(.async(.logoutUser))
                                    }
                                }
                            }

                        case .apple:
                            send(.async(.logoutUser))
                        default:
                            break
                        }
                    }
                    
                case .logoutUseResponse(let result):
                    switch result{
                    case .success(let userData):
                        state.userLogoutModel = userData
                        Log.debug("유저 로그아웃 성공", userData)
                        state.isLogOut = true
                        state.destination = .home(.init(isLogOut: state.isLogOut, isDeleteUser: state.isDeleteUser, isChangeProfile: state.isChangeProfile, isDeleteQuestion: state.isDeleteQuestion))
                    case .failure(let error):
                        Log.debug("유저 로그아웃 에러", error.localizedDescription)
                    }
                    return .none
                    
                case .logoutUser:
                    var loginSocialType = state.loginSocialType
                    return .run { @MainActor send in
                        let userLogOutData = await Result {
                            try await authUseCase.logoutUser(refreshToken: "")
                        }
                        
                        switch userLogOutData {
                        case .success(let userLogOutData):
                            if let userLogOutData = userLogOutData {
                                send(.async(.logoutUseResponse(.success(userLogOutData))))
                                UserDefaults.standard.removeObject(forKey: "ACCESS_TOKEN")
                                loginSocialType = nil
                                send(.view(.closePopUp))
                                try await self.clock.sleep(for: .seconds(0.4))
                                send(.navigation(.presntLogout))
                            }
                            
                        case .failure(let error):
                            send(.async(.logoutUseResponse(.failure(CustomError.map(error)))))
                        }
                    }

                        
                case .fetchQuestion:
                    return .run { @MainActor send in
                        let questionResult = await Result {
                            try await questionUseCase.myQuestionList(page: 1, pageSize: 20)
                        }
                        
                        switch questionResult {
                        case .success(let questionResult):
                            if let questionData = questionResult {
                                send(.async(.fetchQuestionResponse(.success(questionData))))
                            }
                        case .failure(let error):
                            send(.async(.logoutUseResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                    }
                    
                case .fetchQuestionResponse(let result):
                    switch result {
                    case .success(let questionData):
                        state.myQuestionListModel = questionData
                        
                    case .failure(let error):
                        Log.debug("피드 목록 에러", error.localizedDescription)
                    }
                    return .none
                    
                case .deleteQuestion(let questionID):
                    return .run { @MainActor send in
                        let deleteQuestionResult = await Result {
                            try await questionUseCase.deleteQuestion(questionID: questionID)
                        }
                        
                        switch deleteQuestionResult {
                        case .success(let deleteQuestionResult):
                            if let deleteQuestionResult = deleteQuestionResult {
                                send(.async(.deleteQuestionResponse(.success(deleteQuestionResult))))
                                
                                try await self.clock.sleep(for: .seconds(1))
                                send(.navigation(.presntDeleteQuestion))
                            }
                        case .failure(let error):
                            send(.async(.deleteQuestionResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                    }
                
                case .deleteQuestionResponse(let result):
                    switch result {
                    case .success(let deleteQuestionData):
                        state.deleteQuestionModel = deleteQuestionData
                        state.isDeleteQuestion = true
                        
                    case .failure(let error):
                        Log.debug("질문 삭제 에러", error.localizedDescription)
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
                    
                case .presntEditProfile:
                    return .none
                    
                case .presntWithDraw:
                    return .none
                    
                case .presnetCreateQuestionList:
                    return .none
                    
                case .presntDeleteQuestion:
                    return .none
                    
                case .presntUserBlock:
                    return .none
                }
                
            default:
                return .none
                
            }
            
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
