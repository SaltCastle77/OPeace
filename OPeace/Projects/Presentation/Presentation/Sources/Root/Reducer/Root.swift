//
//  Root.swift
//  Presentation
//
//  Created by 서원지 on 8/1/24.
//

import Foundation
import ComposableArchitecture
import KeychainAccess

import Utills
import Utill

@Reducer
public struct Root {
    public init() {}
    
    @ObservableState
    public enum State {
        case homeRoot(HomeRoot.State)
        case auth(Auth.State)
        case onbaordingPagging(OnBoadingPagging.State)
        case signUpPAgging(SignUpPaging.State)
        
        public init() {
            if let token = try? Keychain().get("ACCESS_TOKEN") , !token.isEmpty {
                Log.debug(token)
                self = .homeRoot(.init())
            } else {
                self = .auth(.init())
            }
        }
    }
    
    public enum Action: ViewAction, FeatureAction{
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
       
    }
    
    @CasePathable
    public enum View {
        case auth(Auth.Action)
        case homeRoot(HomeRoot.Action)
        case signupPaging(SignUpPaging.Action)
        case onbaordingPagging(OnBoadingPagging.Action)
    }
    
    //MARK: - 앱내에서 사용하는 액선
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - 비동기 처리 액션
    public enum AsyncAction: Equatable {
        
    }
    
    //MARK: - 네비게이션 연결 액션
    public enum NavigationAction: Equatable {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .view(let View):
                switch View {
                case .onbaordingPagging(.navigation(.presntMainHome)):
                    state = .homeRoot(.init())
                    return .none
                    
                case .auth(.login(.navigation(.presentMain))):
                    state = .homeRoot(.init())
                    return .none
                    
                default:
                    return .none
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                    
                }
                
                
         
            }
        }
        .ifCaseLet(\.homeRoot, action: \.view.homeRoot) {
            HomeRoot()
        }
        .ifCaseLet(\.auth, action: \.view.auth) {
            Auth()
        }
        .ifCaseLet(\.signUpPAgging, action: \.view.signupPaging) {
            SignUpPaging()
        }
    }
}

