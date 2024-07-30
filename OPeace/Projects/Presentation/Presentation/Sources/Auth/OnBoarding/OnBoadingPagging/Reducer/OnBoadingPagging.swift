//
//  OnBoadingPagging.swift
//  Presentation
//
//  Created by 서원지 on 7/30/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Model
import DesignSystem
import Utills


@Reducer
public struct OnBoadingPagging {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var activeMenu: OnBoardingTab = .onBoardingFirst
        var onBoardingFirst = OnBoardingFirst.State()
        
        public init() {}
    }
    
    public enum Action: ViewAction, FeatureAction, BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case activeTabChanged(OnBoardingTab)
        case onBoardingFirst(OnBoardingFirst.Action)
    }
    
    //MARK: - ViewAction
    public enum View {
       
        
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
                
            case .activeTabChanged(let changeTab):
                state.activeMenu = changeTab
                return .none
                
            case .view(let View):
                switch View {
                    
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
        
        Scope(state: \.onBoardingFirst, action: \.onBoardingFirst) {
            OnBoardingFirst()
        }
    }
}

