//
//  SignUpAge.swift
//  Presentation
//
//  Created by 서원지 on 7/26/24.
//

import Foundation
import ComposableArchitecture

import Utill
import SwiftUI

import DesignSystem
import Networkings

@Reducer
public struct SignUpAge {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        

        var signUpAgeTitle: String = "나이 입력"
        var signUpAgeSubTitle: String = "출생 연도를  알려주세요"
         var signUpAgeDisplay = ""
        var signUpAgeDisplayColor: Color = Color.gray500
        var checkGenerationTextColor: Color = Color.gray500
        var checkGenerationText: String = "기타세대"
        var isErrorGenerationText: String = ""
        var presntNextViewButtonTitle = "다음"
        var enableButton: Bool = false
        var signUpName: String? = nil
        var signUpNames: String = ""
        
        var chekcGenerationModel: CheckGeneraionModel? = nil
        @Presents var destination: Destination.State?
        var activeMenu: SignUpTab = .signUpName
        var signUpJob = SignUpJob.State()
        
        public init(
            signUpName: String? = nil
        ) {
            self.signUpName = signUpName
        }
    }
    
    public enum Action: ViewAction, FeatureAction , BindableAction, FeatureScopeAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case switchTabs
//        case apperName
        case scope(ScopeAction)
        case signUpJob(SignUpJob.Action)
    }

    @CasePathable
    public enum View {
        case apperName
        case updateGeneration(generation: String)
    }
    

    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case fetchJobList
        case updateName
        case checkGeneration(year: Int)
        case chekcGenerationResponse(Result<CheckGeneraionModel, CustomError>)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
    
    }
    
    public enum ScopeAction: Equatable {
        case fetchJobList
        
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case signUpJob(SignUpJob)
    }
    
    @Dependency(SignUpUseCase.self) var signUpUseCase
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .switchTabs:
                state.destination = .signUpJob(.init())
                return .none
                
            case .binding(\.signUpAgeDisplay):
                return .none
                
            case .destination(_):
                return .none
                
            case .view(let View):
                switch View {
             
                case .apperName:
                    return .none
                    
                case .updateGeneration(generation: let generation):
                    let (color, textColor) = CheckRegister.getGenerationSignUp(
                        generation: generation,
                        color: state.signUpAgeDisplayColor,
                        textColor: state.checkGenerationTextColor)
//                        store.checkGenerationText = generation
                    state.signUpAgeDisplayColor = color
                    state.checkGenerationTextColor = textColor
                    return .none
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                case .fetchJobList:
                    return .run { @MainActor send in
                        send(.signUpJob(.fetchJob))
                    }
                    
                case .updateName:
                    let signUpName = state.signUpName
                    return .run { @MainActor send in
                        send(.signUpJob(.appearName(signUpName ?? "")))
                    }
                    
                case .checkGeneration(year: let year):
                    var checkGenerationText = state.checkGenerationText
                    var signUpAgeDisplayColor = state.signUpAgeDisplayColor
                    var checkGenerationTextColor = state.checkGenerationTextColor
                    return .run { @MainActor send in
                        let checkGenerationResult = await Result {
                            try await signUpUseCase.checkGeneration(year: year)
                        }
                        
                        switch checkGenerationResult {
                        case .success(let checkGenerationData):
                            if let checkGenerationData = checkGenerationData {
                                send(.async(.chekcGenerationResponse(.success(checkGenerationData))))
                                
                                send(.view(.updateGeneration(generation: checkGenerationData.data?.data ?? "")))
                                
                            }
                        case .failure(let error):
                            send(.async(.chekcGenerationResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                    }
                    
                case .chekcGenerationResponse(let result):
                    switch result {
                    case .success(let checkGenrationResult):
                        state.chekcGenerationModel = checkGenrationResult
                        state.checkGenerationText = checkGenrationResult.data?.data ?? ""
//                        state.checkGenerationText = checkGenrationResult.data?.data
                    case .failure(let error):
                        Log.error("세대 확인 에러", error.localizedDescription)
                    }
                    return .none
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
               
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                    
                }
                     
            case .scope(let ScopeAction):
                switch ScopeAction {
                case .fetchJobList:
                    return .run { @MainActor send in
                        send(.signUpJob(.fetchJob))
                    }
                    
                }
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        Scope(state: \.signUpJob, action: \.signUpJob) {
            SignUpJob()
        }
    }
}
