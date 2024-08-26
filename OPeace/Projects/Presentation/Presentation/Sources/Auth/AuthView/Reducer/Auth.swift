//
//  Auth.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import Foundation
import SwiftUI
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
        @Shared(.inMemory("isLogOut")) var isLogOut: Bool = false
        @Shared(.inMemory("isDeleteUser")) var isDeleteUser: Bool = false
        @Shared(.inMemory("isLookAround")) var isLookAround: Bool = false
        @Shared(.inMemory("isChangeProfile")) var isChangeProfile: Bool = false
        @Shared(.inMemory("createQuestionEmoji")) var emojiText: String = ""
        @Shared(.inMemory("createQuestionTitle")) var createQuestionTitle: String = ""
        @Shared(.inMemory("isCreateQuestion")) var isCreateQuestion: Bool = false
        @Shared(.inMemory("isDeleteQuestion")) var isDeleteQuestion: Bool = false
        @Shared(.inMemory("isReportQuestion")) var isReportQuestion: Bool = false
        @Shared(.inMemory("questionID")) var questionID: Int = 0
        
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
        case withDraw(WithDraw)
        case writeQuestion(WriteQuestion)
        case writeAnswer(WriteAnswer)
        case report(Report)
        
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
        case removeToHome
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
                    
                    //MARK: - Login
                case .element(id: _, action: .login(.navigation(.presentMain))):
                    state.path.append(.home(.init(
                        isLogOut: state.isLogOut,
                        isDeleteUser: state.isDeleteUser,
                        isLookAround: state.isLookAround,
                        isChangeProfile: state.isChangeProfile,
                        isCreateQuestion: state.isCreateQuestion,
                        isDeleteQuestion: state.isDeleteQuestion,
                        isReportQuestion: state.isReportQuestion)))
                    
                case .element(id: _, action: .login(.navigation(.presntLookAround))):
                    state.path.append(.home(.init(
                        isLogOut: state.isLogOut,
                        isDeleteUser: state.isDeleteUser,
                        isLookAround: state.isLookAround,
                        isChangeProfile: state.isChangeProfile,
                        isCreateQuestion: state.isCreateQuestion,
                        isDeleteQuestion: state.isDeleteQuestion,
                        isReportQuestion: state.isReportQuestion)))
                    
                case .element(id: _, action: .login(.navigation(.presnetAgreement))):
                    state.path.append(.agreeMent(.init()))
                    
                    //MARK: - Agree
                case .element(id: _, action: .agreeMent(.navigation(.presntSignUpName))):
                    state.path.append(.signUpPagging(.init()))
                    
                    
                case .element(id: _, action: .agreeMent(.navigation(.presntServiceAgreeCheckTapped))):
                    state.path.append(.webView(.init(url: AgreeMentAPI.seriveTerms.agreeMentDesc)))
                    
                    
                case .element(id: _, action: .agreeMent(.navigation(.presntPrivacyAgreeCheckTapped))):
                    state.path.append(.webView(.init(url: AgreeMentAPI.privacyPolicy.agreeMentDesc)))
                    
                    //MARK: - SignUp
                case .element(id: _, action: .signUpPagging(.navigation(.presntOnboarding))):
                    state.path.append(.onBoardingPagging(.init()))
             
                case .element(id: _, action: .signUpPagging(.navigation(.presntMainHome))):
                    state.path.append(.home(.init(
                        isLogOut: state.isLogOut,
                        isDeleteUser: state.isDeleteUser,
                        isLookAround: state.isLookAround,
                        isChangeProfile: state.isChangeProfile,
                        isCreateQuestion: state.isCreateQuestion,
                        isReportQuestion: state.isReportQuestion)))
                    
                    //MARK: - OnBoarding
                case .element(id: _, action: .onBoardingPagging(.navigation(.presntMainHome))):
                    state.path.append(.home(.init(
                        isLogOut: state.isLogOut,
                        isDeleteUser: state.isDeleteUser,
                        isLookAround: state.isLookAround,
                        isChangeProfile: state.isChangeProfile,
                        isCreateQuestion: state.isCreateQuestion,
                        isDeleteQuestion: state.isDeleteQuestion,
                        isReportQuestion: state.isReportQuestion)))
                    
                    //MARK: - home
                case .element(id: _, action: .home(.navigation(.presntProfile))):
                    state.path.append(.profile(.init()))
                    
                case .element(id: _, action: .home(.navigation(.presntLogin))):
                    state.path.append(.login(.init()))
                          
                case .element(id: _, action: .home(.navigation(.presntWriteQuestion))):
                    state.path.append(.writeQuestion(.init()))
                    
                case .element(id: _, action: .home(.navigation(.presntReport))):
                    state.path.append(.report(.init(
                        questionID: state.questionID
                        
                    )))
                    
                    //MARK: - profile
                case .element(id: _, action: .profile(.navigation(.presntLogout))):
                    state.path.append(.home(.init(
                        isLogOut: state.isLogOut,
                        isDeleteUser: state.isDeleteUser,
                        isLookAround: state.isLookAround,
                        isChangeProfile: state.isChangeProfile,
                        isCreateQuestion: state.isCreateQuestion,
                        isDeleteQuestion: state.isDeleteQuestion)
                    ))
                    state.path.removeFirst()
                    
                case .element(id: _, action: .profile(.navigation(.presntEditProfile))):
                    state.path.append(.editProfile(.init()))
                    
                case .element(id: _, action: .profile(.navigation(.presntWithDraw))):
                    state.path.append(.withDraw(.init()))
                    
                case .element(id: _, action: .profile(.navigation(.presnetCreateQuestionList))):
                    state.path.append(.writeQuestion(.init()))
                    
                case .element(id: _, action: .profile(.navigation(.presntDeleteQuestion))):
                    let homeState = Home.State()
                    state.path.removeAll { path in
                        switch path {
                        case .editProfile, .profile, .withDraw:
                            return true
                        case .home:
                            return false
                        default:
                            return true
                        }
                    }
                    if !state.path.contains(where: { $0 == .home(homeState) }) {
                        state.path.append(.home(homeState))
                    }
                    
                    //MARK: - WithDraw
                case  .element(id: _, action: .withDraw(.navigation(.presntDeleteUser))):
                    let homeState = Home.State()
                    state.path.removeAll { path in
                        switch path {
                        case .editProfile, .profile, .withDraw:
                            return true
                        case .home:
                            return false
                        default:
                            return true
                        }
                    }
                    if !state.path.contains(where: { $0 == .home(homeState) }) {
                        state.path.append(.home(homeState))
                    }
                    
                    //MARK: - CreateQuestion
                case .element(id: _, action: .writeQuestion(.navigation(.presntWriteAnswer))):
                    state.path.append(.writeAnswer(.init(
                        createQuestionEmoji: state.emojiText,
                        createQuestionTitle: state.createQuestionTitle)
                    ))
                    
                case .element(id: _, action: .writeAnswer(.navigation(.presntMainHome))):
                    let homeState = Home.State()
                    state.path.removeAll { path in
                        switch path {
                        case .editProfile, .profile, .withDraw, .writeAnswer, .writeQuestion:
                            return true
                        case .home:
                            return false
                        default:
                            return true
                        }
                    }
                    if !state.path.contains(where: { $0 == .home(homeState) }) {
                        state.path.append(.home(homeState))
                    }
                    
                    //MARK: - Report
                case .element(id: _, action: .report(.navigation(.presntMainHome))):
                    let homeState = Home.State()
                    state.path.removeAll { path in
                        switch path {
                        case .report:
                            return true
                        case .home:
                            return false
                        default:
                            return false
                        }
                    }
                    if !state.path.contains(where: { $0 == .home(homeState) }) {
                        state.path.append(.home(homeState))
                    }
                    
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
                    
                case .removeToHome:
                    let homeState = Home.State()

                    
                    state.path.removeAll { path in
                        switch path {
                        case .editProfile, .profile:
                            return true
                        case .home:
                            return false
                        default:
                            return true
                        }
                    }
                    if !state.path.contains(where: { $0 == .home(homeState) }) {
                        state.path.append(.home(homeState))
                    }

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
