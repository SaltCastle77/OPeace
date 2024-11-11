//
//  Root.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import TCACoordinators

import Utill
import API

@Reducer
public struct HomeCoordinator {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var routes: [Route<HomeScreen.State>]
    
    var home = Home.State()
    var profile = Profile.State()
    var report = Report.State()
    var createQuestion = CreateQuestionCoordinator.State()
    
    @Shared(.inMemory("userInfoModel")) var userInfoModel: UserInfoModel? = nil
    @Shared(.inMemory("questionID")) var questionID: Int = 0
    
    
    public init() {
      @Shared(.inMemory("userInfoModel")) var userInfoModel: UserInfoModel? = .init()
      self.routes = [.root(.home(.init(userInfoModel: userInfoModel)), embedInNavigationView: true)]
    }
    
  }
  
  public enum Action : ViewAction, FeatureAction {
    case router(IndexedRouterActionOf<HomeScreen>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
    case home(Home.Action)
    case profile(Profile.Action)
    case createQuestion(CreateQuestionCoordinator.Action)
    case report(Report.Action)
  }
  
  
  //MARK: - ViewAction
  public enum View {
    
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
    case presntAuth
  }
  
  
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .router(let routeAction):
        return routerAction(state: &state, action: routeAction)
        
      case .view(let viewAction):
        return handleViewAction(state: &state, action: viewAction)
        
      case .async(let asyncAction):
        return handleAsyncAction(state: &state, action: asyncAction)
        
      case .inner(let innerAction):
        return handleInnerAction(state: &state, action: innerAction)
        
      case .home(.navigation(.presntProfile)):
        return .send(.profile(.async(.fetchUser)))
        
      case .navigation(let navigationAction):
        return handleNavigationAction(state: &state, action: navigationAction)
        
      default:
        return .none
      }
    }
    .forEachRoute(\.routes, action: \.router)
    Scope(state: \.home, action: \.home) {
      Home()
    }
    Scope(state: \.profile, action: \.profile) {
      Profile()
    }
    Scope(state: \.createQuestion, action: \.createQuestion) {
      CreateQuestionCoordinator()
    }
    Scope(state: \.report, action: \.report) {
      Report()
    }
  }
  
  private func routerAction(
    state: inout State,
    action: IndexedRouterActionOf<HomeScreen>
  ) -> Effect<Action> {
    switch action {
      //MARK: - Home
    case .routeAction(id: _, action: .home(.navigation(.presntProfile))):
      return .routeWithDelaysIfUnsupported(state.routes, action: \.router) {
        $0.push(.profile(.init()))
      }
      
      //MARK: - 로그인
    case .routeAction(id: _, action: .home(.navigation(.presntLogin))):
      return .send(.navigation(.presntAuth))
      
      //MARK: - 질문 등록 하기
    case .routeAction(id: _, action: .home(.navigation(.presntWriteQuestion))):
      state.routes.push(.createQuestion(.init()))
      return .none
      
      //MARK: - 신고하기
    case .routeAction(id: _, action: .home(.navigation(.presntReport))):
      state.routes.push(.report(.init(questionID: state.questionID)))
      return .none
      
    case .routeAction(id: _, action: .report(.navigation(.presntMainHome))):
      state.routes.goBackToRoot()
      return .none
      
      //MARK: - 프로필 화면
      //MARK: - logout
    case .routeAction(id: _, action: .profile(.navigation(.presntLogout))):
      state.routes.goBackToRoot()
      return .none
      
      //MARK: - 프로필 수정
    case .routeAction(id: _, action: .profile(.navigation(.presntEditProfile))):
      state.routes.push(.editProfile(.init()))
      return .none
      
      //MARK: - withDraw 회원 탈퇴
    case .routeAction(id: _, action: .profile(.navigation(.presntWithDraw))):
      state.routes.push(.withDraw(.init()))
      return .none
      
    case .routeAction(id: _, action: .withDraw(.navigation(.presntDeleteUser))):
      return .routeWithDelaysIfUnsupported(state.routes, action: \.router) {
        $0.goBackTo(\.home)
      }
      
    case .routeAction(id: _, action: .profile(.navigation(.presntUserBlock))):
      state.routes.push(.blockUser(.init()))
      return .none
      
      //MARK: - 내가 작성한 글 삭제
    case .routeAction(id: _, action: .profile(.navigation(.presntDeleteQuestion))):
      state.routes.goBackTo(\.home)
      return .none
      
      //MARK: - 작성한 글이 없을때
    case .routeAction(id: _, action: .profile(.navigation(.presnetCreateQuestionList))):
      state.routes.push(.createQuestion(.init()))
      return .none
      
    case .routeAction(id: _, action: .createQuestion(.navigation(.presntHome))):
      state.routes.goBackTo(\.home)
      return .none
      
    default:
      return .none
    }
    
  }
  
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      
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
    case .removePath:
      return .routeWithDelaysIfUnsupported(state.routes, action: \.router) {
        $0.goBack()
      }
      
    case .removeAllPath:
      return .none
      
    case .removeToHome:
      state.routes.goBackToRoot()
      return .none
    }
  }
  
  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
    case .presntAuth:
      return .none
    }
  }
  
  
}


extension HomeCoordinator {
  
  @Reducer(state: .equatable)
  public enum HomeScreen{
    case home(Home)
    case profile(Profile)
    case editProfile(EditProfile)
    case withDraw(WithDraw)
    case blockUser(BlockUser)
    case report(Report)
    case createQuestion(CreateQuestionCoordinator)
  }
}
