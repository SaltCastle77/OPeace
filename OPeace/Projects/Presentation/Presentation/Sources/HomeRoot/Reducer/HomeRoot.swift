//
//  Root.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import ComposableArchitecture

import Utill

@Reducer
public struct HomeRoot {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var path = StackState<Path.State>()
        var home = Home.State()
    }
    
    public enum Action : ViewAction, FeatureAction {
        case path(StackAction<Path.State, Path.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case home(Home.Action)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case home(Home)
        case profile(Profile)
        case login(Login)
        case editProfile(EditProfile)
    }
    
    //MARK: - ViewAction
    public enum View {
        case appearPath
        
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
        case removePath
         case removeAllPath
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
    
    }
    
    
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(let action):
                switch action {
//                case .element(id: _, action: .home):
                    
                case .element(id: _, action: .home(.navigation(.presntProfile))):
                    state.path.append(.profile(.init()))
                                
                case .element(id: _, action: .profile(.navigation(.presntLogout))):
                    state.path.append(.login(.init()))
                    state.path.removeFirst()
                    
                case .element(id: _, action: .login(.navigation(.presentMain))):
                    state.path.append(.home(.init()))
                    
                    
                case .element(id: _, action: .profile(.navigation(.presntEditProfile))):
                    state.path.append(.editProfile(.init()))
                    
                    
                default:
                    return .none
                                
                }
                return .none
                
            case .view(let View):
                switch View {
                case .appearPath:
                    state.path.append(.home(.init()))
                    return .none
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
                case .removePath:
                    state .path.removeLast()
                    return .none
                    
                case .removeAllPath:
                    state.path.removeAll()
                    return .none
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                    
                }
                
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        Scope(state: \.home, action: \.home) {
            Home()
        }
    }
}

