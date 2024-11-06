//
//  Setting.swift
//  Presentation
//
//  Created by 서원지 on 8/1/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Model
import UseCase
import Utills

@Reducer
public struct Setting {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var settingtitem: SettingProfile? = nil
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
        case tapSettingitem(SettingProfile)
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
    
    @Dependency(AuthUseCase.self) var authUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .test:
                return .none
            case .view(let View):
                switch View {
                case .tapSettingitem(let item):
                    state.settingtitem = item
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
            }
        }
    }
}
