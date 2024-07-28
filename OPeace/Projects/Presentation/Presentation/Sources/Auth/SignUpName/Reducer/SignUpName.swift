//
//  SignUpName.swift
//  Presentation
//
//  Created by 서원지 on 7/24/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Service
import Utills
import Model
import UseCase
import KeychainAccess

@Reducer
public struct SignUpName {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var signUpNameTitle: String = "닉네임 입력"
        var signUpNameSubTitle: String = "2~5자까지 입력할 수 있어요"
         var signUpNameDisplay = ""
        var presntNextViewButtonTitle = "다음"
        var nickNameModel: CheckNickName? = nil
        var checkNickNameMessage: String = ""
        var enableButton: Bool = false
    
        @Presents var destination: Destination.State?
        var activeMenu: SignUpTab = .signUpName
    }
    
    public enum Action: ViewAction, FeatureAction , BindableAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case switchSettingTab
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case signUpNameDisplay(text: String)
       
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case checkNickName(nickName: String)
        case checkNIckNameResponse(Result<CheckNickName, CustomError>)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case signUpAge(SignUpAge)
        case signUpJob(SignUpJob)
    }
    
    @Dependency(SignUpUseCase.self) var signUpUseCase
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.signUpNameDisplay):
                return .none
               
            case .switchSettingTab:
                state.activeMenu = .signUpGeneration
                state.destination = .signUpAge(.init(signUpName: state.signUpNameDisplay))
                state.destination = .signUpJob(.init(signUpName: state.signUpNameDisplay))
                return .none
                
            case .view(let View):
                switch View {
               
             
                case .signUpNameDisplay(text: let text):
                    state.signUpNameDisplay = text
                    return .none
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
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
                        state.enableButton =  state.nickNameModel?.exists ?? false
                        
                    case .failure(let error):
                        Log.network("닉네임 에러", error.localizedDescription)
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
//        .onChange(of: \.signUpNameDisplay) { oldValue, newValue in
//            Reduce { state, action in
//                state.signUpNameDisplay = newValue
//                return .none
//            }
//        }
    }
}

