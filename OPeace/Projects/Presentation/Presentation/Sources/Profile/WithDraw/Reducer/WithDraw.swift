//
//  WithDraw.swift
//  Presentation
//
//  Created by 서원지 on 8/12/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Networkings

import KakaoSDKAuth
import KakaoSDKUser


@Reducer
public struct WithDraw {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var withDrawTitle: String = ""
    var withDrawButtonComplete: String = "완료"
    
    var userDeleteModel: DeletUserDTOModel? = nil
    var revokeAppleResponseModel: OAuthDTOModel? = nil
    
    @Presents var destination: Destination.State?
    
    @Shared(.inMemory("userInfoModel")) var userInfoModel: UserInfoModel? = .init()
    
    public init() {}
  }
  
  public enum Action: ViewAction, BindableAction, FeatureAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
  }
  
  @Reducer(state: .equatable)
  public enum Destination {
    case home(Home)
  }
  
  //MARK: - ViewAction
  @CasePathable
  public enum View {
    
  }
  
  
  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case deleteUserResponse(Result<DeletUserDTOModel, CustomError>)
    case deleteUser(reason: String)
    case deletUserSocialType(reason: String)
    case appleRevoke
    case appleRevokeResponse(Result<OAuthDTOModel, CustomError>)
  }
  
  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    
  }
  
  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case presntDeleteUser
    
  }
  
  @Dependency(AuthUseCase.self) var authUseCase
  @Dependency(\.continuousClock) var clock
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(_):
        return .none
        
      case .destination(_):
        return .none
        
      case .view(let viewAction):
        return handleViewAction(state: &state, action: viewAction)
        
      case .async(let asyncAction):
        return handleAsyncAction(state: &state, action: asyncAction)
        
        
      case .inner(let innerAction):
        return handleInnerAction(state: &state, action: innerAction)
        
      case .navigation(let navigationAction):
        return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
    .ifLet(\.$destination, action: \.destination)
    
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
    case .deleteUser(let reason):
      return .run { send in
        let deleteUserData = await Result {
          try await authUseCase.deleteUser(reason: reason)
        }
        
        switch deleteUserData {
        case .success(let deleteUserData):
          if let deleteUserData = deleteUserData {
            await send(.async(.deleteUserResponse(.success(deleteUserData))))
            
            try await self.clock.sleep(for: .seconds(1))
            if deleteUserData.data.status == true {
              await  send(.navigation(.presntDeleteUser))
            }
          }
        case .failure(let error):
          await send(.async(.deleteUserResponse(.failure(CustomError.map(error)))))
        }
      }
      
    case .deleteUserResponse(let result):
      switch result {
      case .success(let userDeleteData):
        state.userDeleteModel = userDeleteData
        UserDefaults.standard.removeObject(forKey: "REFRESH_TOKEN")
        UserDefaults.standard.removeObject(forKey: "ACCESS_TOKEN")
        state.userInfoModel?.isDeleteUser = true
        state.destination = .home(.init(userInfoModel: state.userInfoModel))
      case .failure(let error):
        Log.debug("회원 탈퇴 에러", error.localizedDescription)
      }
      return .none
      
    case .deletUserSocialType(let reason):
      nonisolated(unsafe) var socialType = UserDefaults.standard.string(forKey: "LoginSocialType")
      return .run { send in
        switch socialType {
        case  "kakao":
          await send(.async(.deleteUser(reason: reason)))
        case "apple":
          await send(.async(.appleRevoke))
          try await clock.sleep(for: .seconds(0.3))
          await send(.async(.deleteUser(reason: reason)))
          
        default:
          break
        }
      }
    case .appleRevoke:
      return .run { send in
        let appleRevokeResult = await Result {
          try await authUseCase.revokeAppleToken()
        }
        
        switch appleRevokeResult {
        case .success(let appleRevokeResultData):
          if let appleRevokeResultData = appleRevokeResultData {
            await send(.async(.appleRevokeResponse(.success(appleRevokeResultData))))
          }
        case .failure(let error):
          await send(.async(.appleRevokeResponse(.failure(CustomError.tokenError(error.localizedDescription)))))
        }
      }
      
      
    case .appleRevokeResponse(let result):
      switch result {
      case .success(let appleTokenResponseData):
        state.revokeAppleResponseModel = appleTokenResponseData
      case .failure(let error):
        Log.error("애플 탈퇴 실패", error.localizedDescription)
      }
      return .none
    }
  }
  
  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      
    }
  }
  
  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
    case .presntDeleteUser:
      return .none
    }
  }
}
