//
//  BlockUser.swift
//  Presentation
//
//  Created by 서원지 on 8/27/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture

import Utill
import DesignSystem
import UseCase
import Utills

@Reducer
public struct BlockUser {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var generationColor: Color = .red
        var userBlockListModel: UserBlockListModel?  = nil
        var realseUserBlocModel: UserBlockModel?  = nil
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
        
    }
    
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case fetchUserBlockList
        case fetchUserBlockResponse(Result<UserBlockListModel, CustomError>)
        case realseUserBlock(blockUserID: String)
        case realseUserBlockResponse(Result<UserBlockModel, CustomError>)
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
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                case .fetchUserBlockList:
                    return .run { @MainActor send in
                        let userBlockResult = await Result {
                            try await authUseCase.fetchUserBlockList()
                        }
                        
                        switch userBlockResult {
                        case .success(let userBlockLIstData):
                            if let userBlockListData = userBlockLIstData {
                                send(.async(.fetchUserBlockResponse(.success(userBlockListData))))
                            }
                            
                        case .failure(let error):
                            send(.async(.fetchUserBlockResponse(.failure(CustomError.userError(error.localizedDescription)))))
                        }
                    }
                    
                case .fetchUserBlockResponse(let result):
                    switch result {
                    case .success(let userBlockListData):
                        state.userBlockListModel = userBlockListData
                    case .failure(let error):
                        Log.error("차단 유저 가져오기 실패", error.localizedDescription)
                    }
                    return .none
                    
                case .realseUserBlock(let blockUserID):
                    return .run { @MainActor send in
                        let realseUserBlockResult = await Result {
                            try await authUseCase.realseUserBlock(userID: blockUserID)
                        }
                        
                        switch realseUserBlockResult {
                        case .success(let realseUserBlockResultData):
                            if let realseUserBlockResultData = realseUserBlockResultData {
                                send(.async(.realseUserBlockResponse(.success(realseUserBlockResultData))))
                            }
                        case .failure(let error):
                            send(.async(.realseUserBlockResponse(.failure(CustomError.userError(error.localizedDescription)))))
                        }
                    }
                    
                case .realseUserBlockResponse(let result):
                    switch result {
                    case .success(let realseUserBlockResult):
                        state.realseUserBlocModel = realseUserBlockResult
                    case .failure(let error):
                        Log.error("유저 차단 해제 에러", error.localizedDescription)
                    }
                    return .none
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
