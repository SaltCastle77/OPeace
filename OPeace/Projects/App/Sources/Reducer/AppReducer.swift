//
//  AppReducer.swift
//  OPeace
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import ComposableArchitecture

import Presentation
import Utill
import KeychainAccess

@Reducer
public struct AppReducer {
    public init() {}
    
    @ObservableState
    public enum State {
        case splash(Splash.State)
        case auth(AuthCoordinator.State)
        case main(HomeCoordinator.State)
        
        
        public init() {
            self = .splash(Splash.State())
//            try? Keychain().removeAll()
            
        }
    }
    
    //MARK: - View action
    public enum Action: ViewAction, FeatureAction {
        
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
    @CasePathable
    public enum View {
        case presntView
        case presentRootView
        case presntAuthView
        case splash(Splash.Action)
        case auth(AuthCoordinator.Action)
        case main(HomeCoordinator.Action)
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
    
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let View):
                switch View {
                 
                case .presntView:
                    return .run { send in
                        await send(.view(.splash(.async(.checkUserVerfiy))))
                    }
                    
                case .splash(.navigation(.presntMain)):
                    return .run { send in
                        try await self.clock.sleep(for: .seconds(4))
                        await send(.view(.presentRootView))
                    }
                    
                case .splash(.navigation(.presntLogin)):
                    return .run { send in
                        try await self.clock.sleep(for: .seconds(4))
                        await send(.view(.presntAuthView))
                    }
                    
                case .auth(.navigation(.presntMainHome)):
                    return .send(.view(.presentRootView))
     
                case .main(.navigation(.presntAuth)):
                    return .send(.view(.presntAuthView))
                    
                case .auth(.login(.navigation(.presentMain))):
                    return .send(.view(.presentRootView))
                    
                case .auth(.login(.navigation(.presntLookAround))):
                    return .send(.view(.presentRootView))
                    
                case .auth(.completeSignUp(.navigation(.presntMainHome))):
                    return .send(.view(.presentRootView))
                    
                case .auth(.onBoarding(.navigation(.presntMainHome))):
                    return .send(.view(.presentRootView))

                    
                case .presentRootView:
                    state = .main(.init())
                    return .none
                    
                case .presntAuthView:
                    state = .auth(.init())
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
        .ifCaseLet(\.splash, action: \.view.splash) {
            Splash()
        }
        .ifCaseLet(\.auth, action: \.view.auth){
            AuthCoordinator()
        }
        .ifCaseLet(\.main, action: \.view.main) {
            HomeCoordinator()
        }
    }
}

