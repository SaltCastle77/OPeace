//
//  Home.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import Foundation
import ComposableArchitecture

import Utill

@Reducer
public struct Home {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var profileImage: String = "person.fill"
        var profile = Profile.State()
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case profile(Profile.Action)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        case appaerProfiluserData
    }
    
  
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
       
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntProfile
    
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
               
            
            case .view(let View):
                switch View {
                case .appaerProfiluserData:
                    return .run { @MainActor send in
                        send(.profile(.scopeFetchUser))
                    }
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
               
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                case .presntProfile:
                    return .run { @MainActor send in
                        send(.profile(.scopeFetchUser))
                    }
                }
                
            default:
                return .none
            }
        }
        Scope(state: \.profile, action: \.profile) {
            Profile()
        }
    }
}

