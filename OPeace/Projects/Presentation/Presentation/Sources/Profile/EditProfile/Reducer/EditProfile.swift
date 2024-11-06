//
//  EditProfile.swift
//  Presentation
//
//  Created by 서원지 on 8/4/24.
//

import Foundation
import ComposableArchitecture
import Networkings
import DesignSystem
import Utills

@Reducer
public struct EditProfile {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var profileUserModel: UpdateUserInfoModel?
        var nickNameModel: CheckNickNameModel?
        var editProfileJobModel: SignUpJobModel?
        var updateUserinfoModel: UpdateUserInfoModel?
        var profileSelectedJob: String?
        var profileName: String = ""
        var editProfileName: String = ""
        var checkNickNameMessage: String = ""
        var editProfileGenerationText: String = ""
        var editProfileComplete = "완료"
        var enableButton: Bool = false
        var profileYear: Int  = 0
        let paddings: [CGFloat] = [47, 25, 32, 47, 24, 32]
        @Presents var destination: Destination.State?
        @Shared(.inMemory("userInfoModel")) var userInfoModel: UserInfoModel? = .init()
        
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
        case customPopUp(CustomPopUp)
        case floatingPopUP(FloatingPopUp)
        
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case selectJob(String)
        case appearPopUp
        case appearFloatingPopUp
        case closePopUp
        case updateGenerationInfo
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case fetchUserProfileResponse(Result<UpdateUserInfoModel, CustomError>)
        case fetchUser
        case checkNickName(nickName: String)
        case checkNIckNameResponse(Result<CheckNickNameModel, CustomError>)
        case editProfileResponse(Result<SignUpJobModel, CustomError>)
        case fetchEditProfileJobList
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
        
        
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    @Dependency(SignUpUseCase.self) var signUpUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.editProfileName):
                return .none
                
            case .view(let View):
                switch View {
                case let .selectJob(job):
                    if state.profileSelectedJob == job {
                        state.profileSelectedJob = nil
                        state.enableButton = false
                    } else {
                        state.profileSelectedJob = job
                        state.enableButton = true
                    }
                    return .none
                    
                case .appearPopUp:
                    state.destination = .customPopUp(.init())
                    return .none
                    
                case .appearFloatingPopUp:
                    state.destination = .floatingPopUP(.init())
                    return .none
                    
                case .closePopUp:
                    state.destination = nil
                    return .none
                    
                
                case .updateGenerationInfo:
                    let generation = CheckRegister.getGenerationText(year: state.profileYear)
                    state.editProfileGenerationText = generation
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
                        state.profileName =  state.profileUserModel?.data?.nickname ?? ""
                        state.profileSelectedJob = state.profileUserModel?.data?.job ?? ""
                        state.profileYear = state.profileUserModel?.data?.year ?? .zero
                    case let .failure(error):
                        Log.network("프로필 오류", error.localizedDescription)
                    }
                    return .none
                    
                case .checkNickName(nickName: let nickName):
                    return .run { @MainActor send in
                        let requset = await Result {
                            try await signUpUseCase.checkNickName(nickName)
                        }
                        
                        switch requset {
                        case .success(let result):
                            if let result = result {
                                send(.async(.checkNIckNameResponse(.success(result))))
                            }
                            
                        case .failure(let error):
                            send(.async(.checkNIckNameResponse(.failure(CustomError.map(error)))))
                        }
                    }
                    
                case .checkNIckNameResponse(let result):
                    switch result {
                    case .success(let data):
                        state.nickNameModel = data
                        state.checkNickNameMessage = state.nickNameModel?.data?.message  ?? ""
                        state.enableButton =  state.nickNameModel?.data?.exists ?? false
                        
                    case .failure(let error):
                        Log.network("닉네임 에러", error.localizedDescription)
                    
                }
                    return .none
                    
                case .editProfileResponse(let result):
                    switch result {
                    case .success(let data):
                        state.editProfileJobModel = data
                        
                    case .failure(let error):
                        Log.network("닉네임 에러", error.localizedDescription)
                    }
                    return .none
                    
                case .fetchEditProfileJobList:
                    return .run  { @MainActor send in
                        let request = await Result {
                            try await self.signUpUseCase.fetchJobList()
                        }
                        
                        switch request {
                        case .success(let data):
                            if let data = data {
                                send(.async(.editProfileResponse(.success(data))))
                            }
                            
                        case .failure(let error):
                            send(.async(.editProfileResponse(.failure(CustomError.map(error)))))
                        }
                    }
                    
                case .updateUserInfo(let nickname, let year, let job, let generation):
                    return .run { @MainActor send in
                        let userInfoResult = await Result {
                            try await signUpUseCase.updateUserInfo(nickname: nickname, year: year, job: job, generation: generation)
                        }
                        
                        switch userInfoResult {
                        case .success(let updateUserInfoData):
                            if let updateUserInfoData = updateUserInfoData {
                                send(.async(.updateUserInfoResponse(.success(updateUserInfoData))))
                                
                            }
                            
                        case .failure(let error):
                            send(.async(.updateUserInfoResponse(.failure(CustomError.map(error)))))
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
                    
                }
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
