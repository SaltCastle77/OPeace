//
//  Login.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import Foundation
import ComposableArchitecture

import DesignSystem
import Utill
import UseCase

import Utills
import Model
import AuthenticationServices
import KeychainAccess


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
        var kakaoModel : KakaoResponseModel? = nil
        var socialType: SocialType? = nil
        var profileUserModel: UpdateUserInfoModel? = nil
        var refreshTokenModel: RefreshModel?
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
        case kakaoLogin
        case kakaoLoginResponse(Result<(String?, String?), CustomError>)
        case loginWIthKakao
        case kakaoLoginApiResponse(Result<KakaoResponseModel, CustomError>)
        case fetchUserProfileResponse(Result<UpdateUserInfoModel, CustomError>)
        case fetchUser
        case refreshTokenResponse(Result<RefreshModel, CustomError>)
        case refreshTokenRequest(refreshToken: String)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presnetAgreement
        case presentMain
    }
    
    
    @Dependency(AuthUseCase.self) var authUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {      
            case .view(let View):
                switch View {
              
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                case .appleLogin(let authData):
                    return .run { @MainActor send in
                        do {
                            let result = try await authUseCase.handleAppleLogin(authData)
                            send(.async(.fetchAppleRespose(.success(result))))
                        } catch {
                            print("Error handling Apple login: \(error)")
                        }
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
                    
                case .kakaoLogin:
                    #if swift(>=6.0)
                    nonisolated(unsafe) var socialType = state.socialType
                    #else
                     var socialType = state.socialType
                    #endif
                    
                    return .run { @MainActor send in
                        let requset = await Result {
                            try await  authUseCase.requestKakaoTokenAsync()
                        }
                        
                        switch requset {
                           
                        case .success(let (accessToken, idToken)):
                            send(.async(.kakaoLoginResponse(.success((accessToken, idToken)))))
                            
                            try await clock.sleep(for: .seconds(2))
                            send(.async(.loginWIthKakao))
                            
                        case let .failure(error):
                            send(.async(.kakaoLoginResponse(.failure(CustomError.map(error)))))
                        }
                       
                    }
                    
               
                case .kakaoLoginResponse(let result):
                    switch result {
                    case .success(let (accessToken, idToken)):
                        state.accessToken = accessToken
                        state.idToken = accessToken
                        state.idToken = idToken
                        Log.debug("카카오 idToken ",  state.idToken,  state.accessToken)
                    case let .failure(error):
                        Log.error("카카오 리턴 에러", error)

                    }
                    return .none
                    
                case .loginWIthKakao:
                    var errorMessgage = state.error
                    guard let accessToken = try? Keychain().get("ACCESS_TOKEN") else { return .none }
                    return .run { @MainActor send in
                        let kakaoRequest = await Result {
                            try await authUseCase.reauestKakaoLogin()
                        }
                        
                        switch kakaoRequest {
                        case .success(let resopnse):
                            if let responseData = resopnse {
                                send(.async(.kakaoLoginApiResponse(.success(responseData))))
                                try await self.clock.sleep(for: .seconds(0.05))
                                
                                send(.async(.fetchUser))
                            }
                            
                        case .failure(let error):
                            send(.async(.kakaoLoginApiResponse(.failure(CustomError.kakaoTokenError(error.localizedDescription)))))
                            errorMessgage = CustomError.kakaoTokenError(error.localizedDescription).recoverySuggestion ?? ""
                        }
                    }
                    
                case .kakaoLoginApiResponse(let data):
                    switch data {
                    case .success(let ResponseData):
                        state.kakaoModel = ResponseData

                        try? Keychain().set(state.kakaoModel?.data?.accessToken ?? "",  key: "ACCESS_TOKEN")
                        state.socialType = .kakao
                        let socialTypeValue =  state.socialType?.rawValue ?? SocialType.apple.rawValue
                        try? Keychain().set(socialTypeValue, key: "socialType")
                        if state.kakaoModel?.data?.accessToken != "" {
                            try? Keychain().set(state.kakaoModel?.data?.refreshToken ?? "", key: "REFRESH_TOKEN")
                            try? Keychain().set( "", key: "LastLogin")
                            UserDefaults.standard.set(false, forKey: "isLogOut")
                        } else {
                            try? Keychain().set(state.kakaoModel?.data?.accessToken ?? "",  key: "ACCESS_TOKEN")
                            try? Keychain().set(state.kakaoModel?.data?.refreshToken ?? "", key: "REFRESH_TOKEN")
                            try? Keychain().set( "", key: "LastLogin")
                            UserDefaults.standard.set(false, forKey: "isLogOut")
                        }
                    case .failure(let error):
                        Log.network("카카오 로그인 에러", error.localizedDescription)
                        state.socialType = .kakao
                        let socialTypeValue =  state.socialType?.rawValue ?? SocialType.apple.rawValue
                        try? Keychain().set(socialTypeValue, key: "socialType")
                    }
                    return .none
                    
                case .fetchUser:
                    return .run { @MainActor send in
                        let fetchUserData = await Result {
                            try await authUseCase.fetchUserInfo()
                        }
                        
                        switch fetchUserData {
                        case .success(let fetchUserResult):
                            if let fetchUserResult = fetchUserResult {
                                send(.async(.fetchUserProfileResponse(.success(fetchUserResult))))
                                
                                if fetchUserResult.data?.nickname != nil && fetchUserResult.data?.year != nil && fetchUserResult.data?.job != nil {
                                    send(.navigation(.presentMain))
                                } else {
                                     UserDefaults.standard.set("true", forKey: "isFirstTimeUser")
                                    send(.navigation(.presnetAgreement))
                                }
                                
                            }
                        case .failure(let error):
                            send(.async(.fetchUserProfileResponse(.failure(CustomError.map(error)))))
                            
                        }
                    }
                    
                case .fetchUserProfileResponse(let result):
                    switch result {
                    case .success(let resultData):
                        state.profileUserModel = resultData
                    case let .failure(error):
                        Log.network("프로필 오류", error.localizedDescription)
                    }
                    return .none
                    
                case .refreshTokenRequest(let refreshToken):
                    return .run { @MainActor send in
                        let refreshTokenRequest =  await Result {
                            try await authUseCase.requestRefreshToken(refreshToken: refreshToken)
                        }
                        
                        switch refreshTokenRequest {
                        case .success(let refreshTokenData):
                            if let refreshTokenData = refreshTokenData {
                                send(.async(.refreshTokenResponse(.success(refreshTokenData))))
                            }
                        case .failure(let error):
                            send(.async(.refreshTokenResponse(.failure(CustomError.map(error)))))
                        }
                        
                    }
                    
                case .refreshTokenResponse(let result):
                    switch result {
                    case .success(let refreshTokenData):
                        state.refreshTokenModel = refreshTokenData
                        Log.network("리프레쉬 토큰 발급", refreshTokenData)
                        Log.network("refershToken", refreshTokenData)
                        try? Keychain().remove("ACCESS_TOKEN")
                        try? Keychain().set(state.refreshTokenModel?.data?.accessToken ?? "", key: "ACCESS_TOKEN")
                        
                    case .failure(let error):
                        Log.network("리프레쉬 토큰 발급 에러", error.localizedDescription)
                    }
                    return .none
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
                
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                case .presnetAgreement:
                    return .none
                    
                case .presentMain:
                    try? Keychain().set("1", key: "LastLogin")
                    return .none
                }
            }
            
        }
    }
}

