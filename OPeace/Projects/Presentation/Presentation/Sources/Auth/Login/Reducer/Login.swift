//
//  Login.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import Foundation
import AuthenticationServices

import ComposableArchitecture

import DesignSystem
import Utill
import Networkings

@Reducer
public struct Login {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public init() {}
    var googleLoginImage: ImageAsset = .googleLogin
    var kakaoLoginImage: ImageAsset = .kakaoLogin
    var appLogoImage: ImageAsset = .appLogo
    var appleLoginImage: ImageAsset = .appleLogin
    var notLogingLookAroundText: String = "로그인 없이 둘러보기"
    var nonce: String = ""
    var appleAccessToken: String = ""
    var error: String = ""
    var accessToken: String?
    var idToken: String?
    
    var userLoginModel : OAuthDTOModel? = nil
    var socialType: SocialType? = nil
    var profileUserModel: UpdateUserInfoDTOModel? = nil
    var refreshTokenModel: RefreshDTOModel?
    var appleRefreshTokenMode: OAuthDTOModel? = nil
    
    @Shared(.inMemory("userInfoModel")) var userInfoModel: UserInfoModel? = .init()
    @Shared(.inMemory("isLookAround")) var isLookAround: Bool = false
    @Shared(.inMemory("isLogOut")) var isLogOut: Bool = false
    @Shared(.inMemory("isDeleteUser")) var isDeleteUser: Bool = false
    @Shared(.inMemory("isChangeProfile")) var isChangeProfile: Bool = false
    @Shared(.inMemory("loginSocialType")) var loginSocialType: SocialType? = nil
    @Shared(.appStorage("lastViewedPage")) var lastViewedPage: Int = .zero
  }
  
  public enum Action: ViewAction ,FeatureAction {
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
  }
  
  
  
  //MARK: - ViewAction
  public enum View {
    
  }
  
  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction  {
    case fetchAppleRespose(Result<ASAuthorization, Error>)
    case appleLogin(Result<ASAuthorization, Error>)
    case loginWithApple(token: String)
    case loginWithAppleResponse(Result<OAuthDTOModel, CustomError>)
    case appleGetRefreshToken
    case appleResponseRefreshToken(Result<OAuthDTOModel, CustomError>)
    case kakaoLogin
    case kakaoLoginResponse(Result<(String?, String?), CustomError>)
    case loginWIthKakao
    case kakaoLoginApiResponse(Result<OAuthDTOModel, CustomError>)
    case fetchUserProfileResponse(Result<UpdateUserInfoDTOModel, CustomError>)
    case fetchUser
    case refreshTokenResponse(Result<RefreshDTOModel, CustomError>)
    case refreshTokenRequest(refreshToken: String)
  }
  
  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    
  }
  
  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case presnetAgreement
    case presentMain
    case presntLookAround
  }
  
  
  @Dependency(AuthUseCase.self) var authUseCase
  @Dependency(\.continuousClock) var clock
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
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
      
    case .appleLogin(let authData):
      nonisolated(unsafe) var appleAccessToken = state.appleAccessToken
      return .run { send in
        do {
          let result = try await authUseCase.handleAppleLogin(authData)
          await send(.async(.fetchAppleRespose(.success(result))))
          await send(.async(.loginWithApple(token: appleAccessToken)))
        } catch {
          #logDebug("애플 로그인 에러", error.localizedDescription)
        }
      }
      
    case .fetchAppleRespose(let data):
      switch data {
      case .success(let authResult):
        switch authResult.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
          guard let tokenData = appleIDCredential.identityToken,
                let identityToken = String(data: tokenData, encoding: .utf8) else {
            #logError("Identity token is missing")
            return .none
            
          }
          state.appleAccessToken = identityToken
          state.socialType = .apple
        default:
          break
        }
      case .failure(let error):
        #logError("애플로그인 에러", error)
      }
      return .none
      
    case .loginWithApple(let token):
      return .run { @MainActor send in
        let appleLoginResult = await Result {
          try await authUseCase.appleLogin()
        }
        
        switch appleLoginResult {
        case .success(let appleLoginResult):
          if let appleLoginResult = appleLoginResult {
            send(.async(.loginWithAppleResponse(.success(appleLoginResult))))
            try await clock.sleep(for: .seconds(0.1))
            send(.async(.fetchUser))
            send(.async(.appleGetRefreshToken))
          }
        case .failure(let error):
          send(.async(.loginWithAppleResponse(.failure(CustomError.kakaoTokenError(error.localizedDescription)))))
        }
      }
      
    case .loginWithAppleResponse(let result):
      switch result {
      case .success(let ResponseData):
        state.userLoginModel = ResponseData
        UserDefaults.standard.removeObject(forKey: "ACCESS_TOKEN")
        UserDefaults.standard.removeObject(forKey: "REFRESH_TOKEN")
        UserDefaults.standard.set(state.userLoginModel?.data.accessToken ?? "", forKey: "ACCESS_TOKEN")
        state.loginSocialType = .apple
        state.socialType = .apple
        let socialTypeValue =  state.socialType?.rawValue ?? SocialType.apple.rawValue
        UserDefaults.standard.set(socialTypeValue, forKey: "LoginSocialType")
        if state.userLoginModel?.data.accessToken != "" {
          UserDefaults.standard.set(state.userLoginModel?.data.refreshToken ?? "", forKey: "REFRESH_TOKEN")
          UserDefaults.standard.set(state.userLoginModel?.data.accessToken ?? "", forKey: "ACCESS_TOKEN")
          state.userInfoModel?.isLogOut = false
          state.userInfoModel?.isLookAround = false
          
          state.userInfoModel?.isDeleteUser = false
          state.userInfoModel?.isChangeProfile = false
        } else {
          UserDefaults.standard.removeObject(forKey: "ACCESS_TOKEN")
          UserDefaults.standard.removeObject(forKey: "REFRESH_TOKEN")
          UserDefaults.standard.set(state.userLoginModel?.data.accessToken ?? "", forKey: "ACCESS_TOKEN")
          UserDefaults.standard.set(state.userLoginModel?.data.refreshToken ?? "", forKey: "REFRESH_TOKEN")
          state.userInfoModel?.isLogOut = false
          state.userInfoModel?.isLookAround = false
          state.userInfoModel?.isDeleteUser = false
          state.userInfoModel?.isChangeProfile = false
        }
      case .failure(let error):
        #logNetwork("애플 로그인 에러", error.localizedDescription)
        state.socialType = .apple
        state.loginSocialType = .apple
      }
      return .none
      
    case .appleGetRefreshToken:
      nonisolated(unsafe) var appleToken  = UserDefaults.standard.string(forKey: "APPLE_ACCESS_CODE") ?? ""
      return .run { send in
        let appleGetRefreshTokenResult = await Result {
          try await authUseCase.getAppleRefreshToken(code: appleToken)
        }
        
        switch appleGetRefreshTokenResult {
          
        case .success(let appleGetRefreshTokenData):
          if let appleGetRefreshTokenData = appleGetRefreshTokenData {
            await send(.async(.appleResponseRefreshToken(.success(appleGetRefreshTokenData))))
          }
        case .failure(let error):
          await send(.async(.appleResponseRefreshToken(.failure(CustomError.tokenError(error.localizedDescription)))))
        }
      }
      
    case .appleResponseRefreshToken(let result):
      switch result {
      case .success(let appleResponseData):
        state.appleRefreshTokenMode = appleResponseData
        UserDefaults.standard.set(appleResponseData.data.refreshToken, forKey: "APPLE_REFRESH_TOKEN")
      case .failure(let error):
        #logError("애플 토큰 발급 실패", error.localizedDescription)
      }
      return .none
      
    case .kakaoLogin:
#if swift(>=6.0)
      nonisolated(unsafe) var socialType = state.socialType
#else
      var socialType = state.socialType
#endif
      
      return .run { send in
        let requset = await Result {
          try await  authUseCase.requestKakaoTokenAsync()
        }
        
        switch requset {
          
        case .success(let (accessToken, idToken)):
          await send(.async(.kakaoLoginResponse(.success((accessToken, idToken)))))
          
          try await clock.sleep(for: .seconds(0.8))
          await send(.async(.loginWIthKakao))
          
        case let .failure(error):
          await send(.async(.kakaoLoginResponse(.failure(CustomError.map(error)))))
        }
      }
      
    case .kakaoLoginResponse(let result):
      switch result {
      case .success(let (accessToken, idToken)):
        state.accessToken = accessToken
        state.idToken = accessToken
        state.idToken = idToken
        #logDebug("카카오 idToken ",  state.idToken,  state.accessToken)
      case let .failure(error):
        Log.error("카카오 리턴 에러", error)
        
      }
      return .none
      
    case .loginWIthKakao:
      return .run { @MainActor send in
        let kakaoRequest = await Result {
          try await authUseCase.reauestKakaoLogin()
        }
        
        switch kakaoRequest {
        case .success(let resopnse):
          if let responseData = resopnse {
            send(.async(.kakaoLoginApiResponse(.success(responseData))))
            send(.async(.fetchUser))
          }
          
        case .failure(let error):
          send(.async(.kakaoLoginApiResponse(.failure(CustomError.kakaoTokenError(error.localizedDescription)))))
        }
      }
      
    case .kakaoLoginApiResponse(let data):
      switch data {
      case .success(let ResponseData):
        state.userLoginModel = ResponseData
        UserDefaults.standard.set(state.userLoginModel?.data.accessToken ?? "", forKey: "ACCESS_TOKEN")
        state.socialType = .kakao
        state.loginSocialType = .kakao
        let socialTypeValue =  state.socialType?.rawValue ?? SocialType.kakao.rawValue
        UserDefaults.standard.set(socialTypeValue, forKey: "LoginSocialType")
        if state.userLoginModel?.data.accessToken != "" {
          UserDefaults.standard.set(state.userLoginModel?.data.refreshToken ?? "", forKey: "REFRESH_TOKEN")
          UserDefaults.standard.set(state.userLoginModel?.data.accessToken ?? "", forKey: "ACCESS_TOKEN")
          state.userInfoModel?.isLogOut = false
          state.userInfoModel?.isLookAround = false
          state.userInfoModel?.isDeleteUser = false
          state.userInfoModel?.isChangeProfile = false
        } else {
          UserDefaults.standard.set(state.userLoginModel?.data.refreshToken ?? "", forKey: "REFRESH_TOKEN")
          UserDefaults.standard.set(state.userLoginModel?.data.accessToken ?? "", forKey: "ACCESS_TOKEN")
          
          state.userInfoModel?.isLogOut = false
          state.userInfoModel?.isLookAround = false
          state.userInfoModel?.isDeleteUser = false
          state.userInfoModel?.isChangeProfile = false
        }
      case .failure(let error):
        #logNetwork("카카오 로그인 에러", error.localizedDescription)
        state.socialType = .kakao
        state.loginSocialType = .kakao
      }
      return .none
      
    case .fetchUser:
      return .run {  send in
        let fetchUserData = await Result {
          try await authUseCase.fetchUserInfo()
        }
        
        switch fetchUserData {
        case .success(let fetchUserResult):
          if let fetchUserResult = fetchUserResult {
            await send(.async(.fetchUserProfileResponse(.success(fetchUserResult))))
            UserDefaults.standard.set(true, forKey: "isFirstTimeUser")
            
            if fetchUserResult.data.nickname != nil && fetchUserResult.data.year != nil && fetchUserResult.data.job != nil {
              await send(.navigation(.presentMain))
            } else {
              await send(.navigation(.presnetAgreement))
            }
            
          }
        case .failure(let error):
          await send(.async(.fetchUserProfileResponse(.failure(CustomError.map(error)))))
          
        }
      }
      
    case .fetchUserProfileResponse(let result):
      switch result {
      case .success(let resultData):
        state.profileUserModel = resultData
      case let .failure(error):
        #logNetwork("프로필 오류", error.localizedDescription)
      }
      return .none
      
    case .refreshTokenRequest(let refreshToken):
      return .run {  send in
        let refreshTokenRequest =  await Result {
          try await authUseCase.requestRefreshToken(refreshToken: refreshToken)
        }
        
        switch refreshTokenRequest {
        case .success(let refreshTokenData):
          if let refreshTokenData = refreshTokenData {
            await send(.async(.refreshTokenResponse(.success(refreshTokenData))))
          }
        case .failure(let error):
          await send(.async(.refreshTokenResponse(.failure(CustomError.map(error)))))
        }
        
      }
      
    case .refreshTokenResponse(let result):
      switch result {
      case .success(let refreshTokenData):
        state.refreshTokenModel = refreshTokenData
        #logNetwork("리프레쉬 토큰 발급", refreshTokenData)
        #logNetwork("refershToken", refreshTokenData)
        UserDefaults.standard.set(state.refreshTokenModel?.data.refreshToken ?? "", forKey: "REFRESH_TOKEN")
        UserDefaults.standard.set(state.refreshTokenModel?.data.accessToken ?? "", forKey: "ACCESS_TOKEN")
        
      case .failure(let error):
        #logNetwork("리프레쉬 토큰 발급 에러", error.localizedDescription)
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
    case .presnetAgreement:
      return .none
      
    case .presentMain:
      return .none
      
    case .presntLookAround:
      state.userInfoModel?.isLogOut = false
      state.userInfoModel?.isLookAround = true
      state.lastViewedPage = 0
      return .none
    }
  }
}

