//
//  Auth.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import Foundation
import ComposableArchitecture

import Utill

@Reducer
public struct Auth {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var path: StackState<Path.State> = .init()
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case login(Login)
        case agreeMent(AgreeMent)
    }
    
    public enum Action: ViewAction ,FeatureAction {
        case path(StackAction<Path.State, Path.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
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
            case let .path(action):
                switch action {
                case .element(id: _, action: .login(.navigation(.presnetAgreement))):
                    state.path.append(.agreeMent(.init()))
                    return .none
                    
                default:
                    break
                }
                return .none
                
            case .view(let View):
                switch View {
                case .appearPath:
                    state.path.append(.login(.init()))
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
            }
        }
        .forEach(\.path, action: \.path)
    }
}
