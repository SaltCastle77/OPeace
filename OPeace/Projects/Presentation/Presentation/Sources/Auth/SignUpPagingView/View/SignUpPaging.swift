//
//  SignUpPaging.swift
//  Presentation
//
//  Created by 서원지 on 7/24/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Model

@Reducer
public struct SignUpPaging {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
         var signUpName = SignUpName.State()
         var signUpAge = SignUpAge.State()
        var signUpAges = SignUpAge.State()
        var signUpJob = SignUpJob.State()
        var activeMenu: SignUpTab = .signUpName
        
        
    }
    
    public enum Action: ViewAction, FeatureAction, BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case signUpName(SignUpName.Action)
        case signUpAge(SignUpAge.Action)
        case signUpJob(SignUpJob.Action)
        case activeTabChanged(SignUpTab)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        
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
               
            case .activeTabChanged(let changeTab):
                state.activeMenu = changeTab
                return .none
                
            case .signUpName(.switchSettingTab):
                state.activeMenu = .signUpGeneration
//                state.selectedTab = 1
                return .none
                
            case .signUpAge(.switchTabs):
                state.activeMenu = .signUpJob
//                state.selectedTab = 1
                return .none
                
                
//            case .signUpJob(.switchTabs):
//                state.activeMenu = .signUpJob
////                state.selectedTab = 1
//                return .none
                
                
                
            case .view(let View):
                switch View {
                    
               
                case .backSelectTab:
                    if state.activeMenu == .signUpGeneration {
                        state.activeMenu = .signUpGeneration
                    } else if state.activeMenu == .signUpGeneration {
                        state.activeMenu = .signUpName
                    }
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
        Scope(state: \.signUpName, action: \.signUpName) {
            SignUpName()
        }
        Scope(state: \.signUpAge, action: \.signUpAge) {
            SignUpAge()
        }
        Scope(state: \.signUpJob, action: \.signUpJob) {
            SignUpJob()
        }
    }
}
