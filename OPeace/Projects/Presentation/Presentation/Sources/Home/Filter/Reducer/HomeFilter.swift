//
//  HomeFilter.swift
//  Presentation
//
//  Created by 염성훈 on 8/25/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Model
import UseCase
import Utills

@Reducer
public struct HomeFilter  {
    public init() {}
    
    @ObservableState
    public struct State : Equatable {
        
        var jsobListModel: SignUpJobModel? = nil
        var generationListModel: GenerationListResponse? = nil
        public var homeFilterTypeState: HomeFilterEnum? = nil
        public var selectedItem: String? = nil
        
        public init(homeFilterEnum: HomeFilterEnum) {
            homeFilterTypeState = homeFilterEnum
        }
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case test
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case tapSettintitem(HomeFilterEnum)
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case fetchListByFilterEnum(HomeFilterEnum)
        case fetchJobList
        case fetchJobResponse(Result<SignUpJobModel, CustomError>)
        case fetchGenerationResponse(Result<GenerationListResponse, CustomError>)
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
        
        Reduce<State, Action> { state, action  in
            switch action {
            case .binding(\.selectedItem):
                return .none
            case .binding(_):
                return .none
            case .view(let ViewAction):
                switch ViewAction {
                case .tapSettintitem(let homefilter):
                    state.homeFilterTypeState = homefilter
                    return .none
                }
                
            case .async(let asyncAction):
                switch asyncAction {
                case .fetchListByFilterEnum(let homeFilterType):
                    state.homeFilterTypeState = homeFilterType
                    switch homeFilterType {
                    case .job:
                        return .run { @MainActor  send in
                            let result = await Result {
                                try await self.signUpUseCase.fetchJobList()
                            }
                            
                            switch result  {
                            case .success(let data):
                                if let data  = data {
                                    send(.async(.fetchJobResponse(.success(data))))
                                }
                            case .failure(let error):
                                send(.async(.fetchJobResponse(.failure(CustomError.map(error)))))
                            }
                        }
                    case .generation:
                        return .run { @MainActor send in
                            let result = await Result {
                                try await self.signUpUseCase.fetchGenerationList()
                            }
                            
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    send(.async(.fetchGenerationResponse(.success(data))))
                                }
                            case .failure(let error):
                                send(.async(.fetchGenerationResponse(.failure(CustomError.map(error)))))
                            }
                        }
                    default:
                        return .none
                    }
                    
                case .fetchJobList:
                    return .run { @MainActor  send in
                        let result = await Result {
                            try await self.signUpUseCase.fetchJobList()
                        }
                        
                        switch result  {
                        case .success(let data):
                            if let data  = data {
                                send(.async(.fetchJobResponse(.success(data))))
                            }
                        case .failure(let error):
                            send(.async(.fetchJobResponse(.failure(CustomError.map(error)))))
                        }
                        
                    }
                case .fetchJobResponse(let result):
                    switch result {
                    case .success(let data):
                        state.jsobListModel  = data
                    case .failure(let error):
                        Log.network("JobList 에러", error.localizedDescription)
                    }
                    
                    return .none
                case .fetchGenerationResponse(let result):
                    switch result {
                    case .success(let data):
                        state.generationListModel = data
                    case .failure(let error):
                        Log.network("generationList 에러", error.localizedDescription)
                    }
                    
                    return .none
                }
            case .test:
                return .none
            }
        }
        .onChange(of: \.selectedItem) { oldValue, newValue in
            Reduce { state, action in
                state.selectedItem = newValue
                return .none
            }
        }
    }

    
}
