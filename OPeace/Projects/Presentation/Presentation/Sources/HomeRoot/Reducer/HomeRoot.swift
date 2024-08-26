//
//  Root.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

import Utill
import API

@Reducer
public struct HomeRoot {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var path = StackState<Path.State>()
        var home = Home.State()
        @Shared(.inMemory("isLogOut")) var isLogOut: Bool = false
        @Shared(.inMemory("isDeleteUser")) var isDeleteUser: Bool = false
        @Shared(.inMemory("isLookAround")) var isLookAround: Bool = false
        @Shared(.inMemory("isChangeProfile")) var isChangeProfile: Bool = false
        @Shared(.inMemory("createQuestionEmoji")) var emojiText: String = ""
        @Shared(.inMemory("createQuestionTitle")) var createQuestionTitle: String = ""
        @Shared(.inMemory("emojiImage")) var emojiImage: Image? = nil
        @Shared(.inMemory("isCreateQuestion")) var isCreateQuestion: Bool = false
        @Shared(.inMemory("isDeleteQuestion")) var isDeleteQuestion: Bool = false
        @Shared(.inMemory("isReportQuestion")) var isReportQuestion: Bool = false
        @Shared(.inMemory("questionID")) var questionID: Int = 0
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
        case agreeMent(AgreeMent)
        case signUpPagging(SignUpPaging)
        case webView(Web)
        case onBoardingPagging(OnBoadingPagging)
        case withDraw(WithDraw)
        case writeQuestion(WriteQuestion)
        case writeAnswer(WriteAnswer)
        case report(Report)
        
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
        case removeToHome
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
                    
                case .element(id: _, action: .login(.navigation(.presnetAgreement))):
                    state.path.append(.agreeMent(.init()))
                    
                case .element(id: _, action: .login(.navigation(.presntLookAround))):
                    state.path.append(.home(.init(
                        isLogOut: state.isLogOut,
                        isDeleteUser: state.isDeleteUser,
                        isLookAround: state.isLookAround,
                        isChangeProfile: state.isChangeProfile,
                        isCreateQuestion: state.isCreateQuestion,
                        isDeleteQuestion: state.isDeleteQuestion,
                        isReportQuestion: state.isReportQuestion)))
                    
                    
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
                        isDeleteQuestion: state.isDeleteQuestion,
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
                        isCreateQuestion: state.isCreateQuestion)
                    ))
                    state.path.removeFirst()
                    
                case .element(id: _, action: .profile(.navigation(.presntEditProfile))):
                    state.path.append(.editProfile(.init()))
                        
                case .element(id: _, action: .profile(.navigation(.presntWithDraw))):
                    state.path.append(.withDraw(.init()))
                    
                case .element(id: _, action: .profile(.navigation(.presntDeleteQuestion))):
                    state.path.removeAll { path in
                        switch path {
                        case .editProfile, .profile, .withDraw:
                            return true
                        default:
                            return false
                        }
                    }
            
                case .element(id: _, action: .profile(.navigation(.presnetCreateQuestionList))):
                    state.path.append(.writeQuestion(.init()))
                    
                    //MARK: - WithDraw
                case  .element(id: _, action: .withDraw(.navigation(.presntDeleteUser))):
                    state.path.removeAll { path in
                        switch path {
                        case .editProfile, .profile, .withDraw:
                            return true
                        default:
                            return false
                        }
                    }
                    
                    //MARK: - Report
                case .element(id: _, action: .report(.navigation(.presntMainHome))):
                    state.path.removeAll { path in
                        switch path {
                        case .report:
                            return true
                        default:
                            return false
                        }
                    }
            
                    
                    //MARK: - CreateQuestion
                case .element(id: _, action: .writeQuestion(.navigation(.presntWriteAnswer))):
                    state.path.append(.writeAnswer(.init(
                        createQuestionEmoji: state.emojiText,
                        createQuestionTitle: state.createQuestionTitle)
                    ))
                    
                case .element(id: _, action: .writeAnswer(.navigation(.presntMainHome))):
                    state.path.removeAll { path in
                        switch path {
                        case .editProfile, .profile, .withDraw, .writeAnswer, .writeQuestion:
                            return true
                        default:
                            return false
                        }
                    }
                    
                
                    
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
                    
                case .removeToHome:
                    state.path.removeAll { path in
                        switch path {
                        case .editProfile, .profile, .withDraw:
                            // Remove if the path is either .edit or .profile
                            return true
                        default:
                            return false
                        }
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
        Scope(state: \.home, action: \.home) {
            Home()
        }
    }
}

