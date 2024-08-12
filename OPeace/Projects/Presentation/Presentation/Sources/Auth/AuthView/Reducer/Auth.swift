//
//  Auth.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Utills

import Model
import UseCase
import API
import AuthenticationServices

@Reducer
public struct Auth {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var path = StackState<Path.State>()
        var emptyModel: EmptyModel?
        var appleAccessToken: String = ""
        var nonce: String = ""
        
        var login = Login.State()
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case login(Login)
        case agreeMent(AgreeMent)
        case signUpPagging(SignUpPaging)
        case webView(Web)
        case root(HomeRoot)
        case onBoardingPagging(OnBoadingPagging)
        case home(Home)
        case profile(Profile)
        case editProfile(EditProfile)
        
        
    }
    
    public enum Action: ViewAction ,FeatureAction {
        case path(StackAction<Path.State, Path.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case login(Login.Action)
    }
    
  
    
    //MARK: - ViewAction
    public enum View {
        case appearPath
        
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction {
        case fetchAppleRespose(Result<ASAuthorization, Error>)
        case appleLogin(Result<ASAuthorization, Error>)
        
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       case removePath
        case removeAllPath
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
    
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {       
            case let .path(action):
                switch action {
//                case .element(id: _, action: .root):
//                return .none
                    
                case .element(id: _, action: .home(.navigation(.presntProfile))):
                    state.path.append(.profile(.init()))
                                
                case .element(id: _, action: .profile(.navigation(.presntLogout))):
                    state.path.append(.home(.init()))
                    state.path.removeFirst()
                    
                case .element(id: _, action: .login(.navigation(.presentMain))):
                    state.path.append(.home(.init()))
                    
                case .element(id: _, action: .login(.navigation(.presntLookAround))):
                    state.path.append(.home(.init()))
                    
                case .element(id: _, action: .profile(.navigation(.presntEditProfile))):
                    state.path.append(.editProfile(.init()))
                    
                case .element(id: _, action: .home(.navigation(.presntLogin))):
                    state.path.append(.login(.init()))
                    
                case .element(id: _, action: .login(.navigation(.presnetAgreement))):
                    state.path.append(.agreeMent(.init()))
                    
                    
                case .element(id: _, action: .agreeMent(.navigation(.presntSignUpName))):
                    state.path.append(.signUpPagging(.init()))
                    
                    
                case .element(id: _, action: .agreeMent(.navigation(.presntServiceAgreeCheckTapped))):
                    state.path.append(.webView(.init(url: AgreeMentAPI.seriveTerms.agreeMentDesc)))
                    
                    
                case .element(id: _, action: .agreeMent(.navigation(.presntPrivacyAgreeCheckTapped))):
                    state.path.append(.webView(.init(url: AgreeMentAPI.privacyPolicy.agreeMentDesc)))
                    
                    
                case .element(id: _, action: .signUpPagging(.navigation(.presntOnboarding))):
                    state.path.append(.onBoardingPagging(.init()))
                    
                    
                case .element(id: _, action: .onBoardingPagging(.navigation(.presntMainHome))):
                    state.path.append(.home(.init()))
                    
                case .element(id: _, action: .signUpPagging(.navigation(.presntMainHome))):
                    state.path.append(.home(.init()))
                    
                default:
                    return .none
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
                    
                case .appleLogin(let authData):
                    return .run { @MainActor send in
                        send(.async(.fetchAppleRespose(authData)))
                    }
                    
                case .fetchAppleRespose(let data):
                    switch data {
                    case .success(let authResult):
                        switch authResult.credential {
                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                            guard let tokenData = appleIDCredential.identityToken,
                                  let identityToken = String(data: tokenData, encoding: .utf8) else {
                                Log.error("Identity token is missing")
                                return .none
                            }
                            state.appleAccessToken = identityToken
                            
                        default:
                            break
                        }
                    case .failure(let error):
                        Log.error("애플로그인 에러", error)
                    }
                    return .none
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
        Scope(state: \.login, action: \.login) {
            Login()
        }
    }
}
