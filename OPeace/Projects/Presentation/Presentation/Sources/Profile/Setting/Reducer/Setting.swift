//
//  Setting.swift
//  Presentation
//
//  Created by 서원지 on 8/1/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Networkings

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
                
            case .view(let viewAction):
              return handleViewAction(state: &state, action: viewAction)
                
            case .async(let asyncAction):
              return handleAsyncAction(state: &state, action: asyncAction)
                
            case .inner(let innerAction):
              return handleInnerAction(state: &state, action: innerAction)
                
            case .navigation(let navigationAction):
              return handleNavigationAction(state: &state, action: navigationAction)
            }
        }
    }
  
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
    case .tapSettingitem(let item):
        state.settingtitem = item
        return .none
    }
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
      
    }
  }
  
  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      
    }
  }
  
  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
   
    }
  }
}
