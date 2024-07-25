//
//  SignUpPaging.swift
//  Presentation
//
//  Created by 서원지 on 7/24/24.
//

import Foundation
import ComposableArchitecture

import Utill

@Reducer
public struct SignUpPaging {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var selectedTab = 0
        var totalTabs = 3
        
        public var signUpName = SignUpName.State()
        
    }
    
    public enum Action: ViewAction, FeatureAction, BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case signUpName(SignUpName.Action)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case activeTabChanged(Int)
        case backSelectTab
        
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
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .view(let View):
                switch View {
                    
                case .activeTabChanged(let selectedTab):
                    state.selectedTab = selectedTab
                    return .none
                case .backSelectTab:
                    state.selectedTab -= 1
                    return .none
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
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
    }
}
