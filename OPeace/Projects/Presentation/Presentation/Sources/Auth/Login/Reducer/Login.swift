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
        var accessToken: String?
        var idToken: String?
        var kakaoModel : KakaoResponse? = nil
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
        case kakaoLoginApiResponse(Result<KakaoResponse, CustomError>)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presnetAgreement
    }
    
    
    @Dependency(AuthUseCase.self) var authUseCase
    
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
                    return .run { @MainActor send in
                        let requset = await Result {
                            try await  authUseCase.requestKakaoTokenAsync()
                        }
                        
                        switch requset {
                        case .success(let (accessToken, idToken)):
                            send(.async(.kakaoLoginResponse(.success((accessToken, idToken)))))
                            
                        case let .failure(error):
                            send(.async(.kakaoLoginResponse(.failure(CustomError.map(error)))))
                        }
                        
                        try await Task.sleep(nanoseconds: 3000000000)
                        send(.async(.loginWIthKakao))
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
                    return .run { @MainActor send in
                        let kakaoRequest = await Result {
                            try await authUseCase.reauestKakaoLogin()
                        }
                        
                        switch kakaoRequest {
                        case .success(let resopnse):
                            if let responseData = resopnse {
                                send(.async(.kakaoLoginApiResponse(.success(responseData))))
                            }
                            
                        case .failure(let error):
                            send(.async(.kakaoLoginApiResponse(.failure(CustomError.map(error)))))
                        }
                    }
                    
                case .kakaoLoginApiResponse(let data):
                    switch data {
                    case .success(let ResponseData):
                        state.kakaoModel = ResponseData
                        
                    case .failure(let error):
                        Log.network("카카오 로그인 에러", error.localizedDescription)
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
                }
            }
            
        }
    }
}

