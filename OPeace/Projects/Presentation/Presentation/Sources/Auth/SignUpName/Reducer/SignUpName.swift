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

@Reducer
public struct SignUpName {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var signUpTitle: String = "닉네임 입력"
        var signUpSubTitle: String = "2~5자까지 입력할 수 있어요"
         var signUpNameDisplay = ""
        var presntNextViewButtonTitle = "다음"
        var nickNameModel: CheckNickName? = nil
        var checkNickNameMessage: String = ""
        var enableButton: Bool = false
    }
    
    public enum Action: ViewAction, FeatureAction , BindableAction {
        case signUpNameDisplay(text: String)
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
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
    
    @Dependency(SignUpUseCase.self) var signUpUseCase
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.signUpNameDisplay):
                state.signUpNameDisplay = state.signUpNameDisplay
                return .none
                
                
            case .signUpNameDisplay(text: let text):
                state.signUpNameDisplay = text
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
//        .onChange(of: \.signUpNameDisplay) { oldValue, newValue in
//            Reduce { state, action in
//                state.signUpNameDisplay = newValue
//                return .none
//            }
//        }
    }
}

