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
        var onBoardingSecond = OnBoadingSecond.State()
        var onBoardingLast = OnBoadringLast.State()
        
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
        case onBoardingSecond(OnBoadingSecond.Action)
        case onBoardingLast(OnBoadringLast.Action)
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
        case presntMainHome
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
                
            case .onBoardingFirst(.switchTab):
                state.activeMenu = .onBoardingSecond
//                state.selectedTab = 1
                return .none
                
            case .onBoardingSecond(.switchTab):
                state.activeMenu = .onBoardingLast
//                state.selectedTab = 1
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
                case .presntMainHome:
                    return .none
                }
                
            default:
                return .none
            }
        }
        
        Scope(state: \.onBoardingFirst, action: \.onBoardingFirst) {
            OnBoardingFirst()
        }
        Scope(state: \.onBoardingSecond, action: \.onBoardingSecond) {
            OnBoadingSecond()
        }
        Scope(state: \.onBoardingLast, action: \.onBoardingLast) {
            OnBoadringLast()
        }
    }
}

