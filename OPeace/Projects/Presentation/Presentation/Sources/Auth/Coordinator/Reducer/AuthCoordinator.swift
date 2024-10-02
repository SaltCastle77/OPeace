//
//  Auth.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import SwiftUI

import AuthenticationServices

import ComposableArchitecture
import TCACoordinators

import Utill
import Networkings


@Reducer
public struct AuthCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var emptyModel: EmptyModel?
        var login = Login.State()
        var completeSignUp = SignUpPaging.State()
        var onBoarding = OnBoadingPagging.State()
        
        var routes: [Route<AuthScreen.State>]
        
        public init() {
            self.routes = [.root(.login(.init()), embedInNavigationView: true)]
        }
        
    }
       
    public enum Action: ViewAction ,FeatureAction {
        case router(IndexedRouterActionOf<AuthScreen>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case login(Login.Action)
        case completeSignUp(SignUpPaging.Action)
        case onBoarding(OnBoadingPagging.Action)
    }
    
  
    
    //MARK: - ViewAction
    public enum View {
        
        
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction {
       
        
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       case removePath
        case removeAllPath
        case removeToHome
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntMainHome
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(let routAction):
                return routerAction(state: &state, action: routAction)
                
                
            case .view(let View):
                switch View {
              
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
                case .removePath:
                    state.routes.goBack()
                    return .none
                    
                case .removeAllPath:
                    return .none
                    
                case .removeToHome:
                    return .none
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
        .forEachRoute(\.routes, action: \.router)
        Scope(state: \.login, action: \.login) {
            Login()
        }
        Scope(state: \.completeSignUp, action: \.completeSignUp) {
            SignUpPaging()
        }
        Scope(state: \.onBoarding, action: \.onBoarding) {
            OnBoadingPagging()
        }
        
    }
    
    private func routerAction(
            state: inout State,
            action: IndexedRouterActionOf<AuthScreen>
    ) -> Effect<Action> {
        switch action {
            //MARK: - Agree
        case .routeAction(id: _, action: .login(.navigation(.presnetAgreement))):
            state.routes.push(.agreeMent(.init()))
            return .none

            //MARK: - webView 동의
        case .routeAction(id: _, action: .agreeMent(.navigation(.presntSignUpName))):
            state.routes.push(.signUpPagging(.init()))
            return .none
            
        case .routeAction(id: _, action: .agreeMent(.navigation(.presntServiceAgreeCheckTapped))):
            state.routes.push(.webView(.init(url: AgreeMentAPI.seriveTerms.agreeMentDesc)))
            return .none
            
        case .routeAction(id: _, action: .agreeMent(.navigation(.presntPrivacyAgreeCheckTapped))):
            state.routes.push(.webView(.init(url: AgreeMentAPI.privacyPolicy.agreeMentDesc)))
            return .none
            
            //MARK: - signUp
        case .routeAction(id: _, action: .signUpPagging(.navigation(.presntOnboarding))):
            state.routes.push(.onBoardingPagging(.init()))
            return .none
            
        case .routeAction(id: _, action: .login(.navigation(.presntLookAround))):
            return .send(.navigation(.presntMainHome))
            
        case .routeAction(id: _, action: .login(.navigation(.presentMain))):
            return .send(.navigation(.presntMainHome))
            
        case .routeAction(id: _, action: .signUpPagging(.navigation(.presntMainHome))):
            return .send(.navigation(.presntMainHome))
            
        case .routeAction(id: _, action: .onBoardingPagging(.navigation(.presntMainHome))):
            return .send(.navigation(.presntMainHome))
            
        default:
            return .none
        }
    }
    
}


extension AuthCoordinator {
    
    @Reducer(state: .equatable)
    public enum AuthScreen {
        case login(Login)
        case agreeMent(AgreeMent)
        case signUpPagging(SignUpPaging)
        case webView(Web)
        case onBoardingPagging(OnBoadingPagging)
    }
}
