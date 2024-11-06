//
//  SignUpJob.swift
//  Presentation
//
//  Created by 서원지 on 7/27/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture

import Utill

import DesignSystem
import Networkings

@Reducer
public struct SignUpJob {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        var signUpJobTitle: String = "직무 선택"
        var signUpJobSubTitle: String = "직무 계열을  알려주세요"
        var signUpName: String? = nil
        var signUpGeneration: String? = nil
        var presntNextViewButtonTitle = "다음"
        var signUpJobModel: SignUpJobModel? = nil
        var enableButton: Bool = false
        var selectedJob: String?
        let paddings: [CGFloat] = [48, 25, 32, 48, 24, 0]
        var backGroudColor = Color.gray600
        
        @Presents var destination: Destination.State?
        
        public init(
            signUpName: String? = nil,
            signUpGeneration: String? = nil
        ) {
            self.signUpName = signUpName
            self.signUpGeneration = signUpGeneration
        }
    }
    
    public enum Action: ViewAction, FeatureAction , BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case fetchJob
        case appearName(String)
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case customPopUp(CustomPopUp)
    }
    
    
    @CasePathable
    public enum View {
        case selectJob(String)
        case appearPopUp
        case closePopUp
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    @CasePathable
    public enum AsyncAction: Equatable {
        case signUpJobResponse(Result<SignUpJobModel, CustomError>)
        case fetchSignUpJobList
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
                
            case .binding(_):
                return .none
                
            case .destination(_):
                return .none
                
            case .fetchJob:
                return .run { @MainActor send in
                    send(.async(.fetchSignUpJobList))
                }
                
            case .appearName(let name):
                state.signUpName = name
                return .none

                
            case .view(let View):
                switch View {
                case let .selectJob(job):
                    if state.selectedJob == job {
                        state.selectedJob = nil
                        state.enableButton = false
                    } else {
                        state.selectedJob = job
                        state.enableButton = true
                    }
                    return .none
                    
                case .appearPopUp:
                    state.destination = .customPopUp(.init())
                    state.backGroudColor = Color.basicBlack.opacity(0.3)
                    return .none
                    
                case .closePopUp:
                    state.destination = nil
                    state.backGroudColor = Color.gray600
                    return .none
                }
                
                
                
            case .async(let AsyncAction):
                switch AsyncAction {
                case .signUpJobResponse(let result):
                    switch result {
                    case .success(let data):
                        state.signUpJobModel = data
                        
                    case .failure(let error):
                        Log.network("닉네임 에러", error.localizedDescription)
                    }
                    return .none
                    
                case .fetchSignUpJobList:
                    return .run  { @MainActor send in
                        let request = await Result {
                            try await self.signUpUseCase.fetchJobList()
                        }
                        
                        switch request {
                        case .success(let data):
                            if let data = data {
                                send(.async(.signUpJobResponse(.success(data))))
                            }
                            
                        case .failure(let error):
                            send(.async(.signUpJobResponse(.failure(CustomError.map(error)))))
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
        .ifLet(\.$destination, action: \.destination)
    }
}

