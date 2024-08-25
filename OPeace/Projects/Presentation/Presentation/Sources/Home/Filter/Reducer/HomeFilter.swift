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
        
        public init() {}
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
        case tapSettintitem(SettingProfile)
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
      
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action  in
            switch action {
                
            case .binding(_):
                return .none
            case .view(_):
                return .none
            case .test:
                return .none
            }
        }
    }

    
}
