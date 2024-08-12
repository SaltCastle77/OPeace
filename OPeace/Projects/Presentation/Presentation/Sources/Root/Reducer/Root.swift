//
//  Root.swift
//  Presentation
//
//  Created by 서원지 on 8/1/24.
//

import Foundation
import ComposableArchitecture
import KeychainAccess

import Utills
import Utill
import UseCase
import Model

@Reducer
public struct Root {
    public init() {}
    
    @ObservableState
    public enum State {
        case homeRoot(HomeRoot.State)
        case auth(Auth.State)
        case onbaordingPagging(OnBoadingPagging.State)
        case signUpPAgging(SignUpPaging.State)
        case profile(Profile.State)
        static var kakaoModel : KakaoResponseModel? = nil
        static var checkUserVerifyModel: CheckUserVerifyModel? = nil
        static var refreshTokenModel: RefreshModel? = nil
        
//        @Shared(.inMemory("isLogOut"))  var isLogOut: Bool = false
//        @Shared(.inMemory("isDeleteUser")) var isDeleteUser: Bool = false
        
        public init() {
            
//            self = .auth(.init())
            
            if let token = try? Keychain().get("ACCESS_TOKEN"), let refreshToken = try? Keychain().get("REFRESH_TOKEN") , !refreshToken.isEmpty && !token.isEmpty {
                Log.debug(token, "refresh : \(refreshToken)")
                self = .homeRoot(.init())
            } else {
                self = .auth(.init())
            }
        }
    }
    
    public enum Action: ViewAction, FeatureAction{
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
       
    }
    
    @CasePathable
    public enum View {
        case auth(Auth.Action)
        case homeRoot(HomeRoot.Action)
        case signupPaging(SignUpPaging.Action)
        case onbaordingPagging(OnBoadingPagging.Action)
        case profile(Profile.Action)
        case changeScene(State)
    }
    
    //MARK: - 앱내에서 사용하는 액선
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case autoLogin
        
        case handleRefreshToken(String)
        case handleKakaoLogin
        
        case loginWIthKakao
        case kakaoLoginApiResponse(Result<KakaoResponseModel, CustomError>)
        
        case refreshTokenResponse(Result<RefreshModel, CustomError>)
        case refreshTokenRequest(refreshToken: String)
        
        case checkUserVerfiy
        case checkUserVerfiyResponse(Result<CheckUserVerifyModel , CustomError>)
        
    }
    
    //MARK: - 네비게이션 연결 액션
    public enum NavigationAction: Equatable {
        
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .view(let View):
                switch View {
                case .onbaordingPagging(.navigation(.presntMainHome)):
                    state = .homeRoot(.init())
                    return .none
                    
                case .auth(.login(.navigation(.presentMain))):
                    state = .homeRoot(.init())
                    return .none
                    
                case .changeScene(let state):
                    var state = state
                    state = state
                    return .none
                    
                case .profile(.navigation(.presntLogout)):
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
                case .autoLogin:
                    guard let socailType = try? Keychain().get("socialType") else { return .none }
                    return .run { @MainActor send in
                        switch socailType {
                        case "kakao":
//                            try await clock.sleep(for: .seconds(1))
                            if let refreshToken = try? Keychain().get("REFRESH_TOKEN") {
                                if refreshToken != nil {
                                    send(.async(.checkUserVerfiy))
                                    send(.async(.loginWIthKakao))
                                }
                            }
                            
                            if let accessToken = try? Keychain().get("ACCESS_TOKEN") {
                                if Root.State.checkUserVerifyModel?.data?.status == false {
                                    if let refreshToken = try? Keychain().get("REFRESH_TOKEN") {
                                        send(.async(.handleRefreshToken(refreshToken)))
                                    } else if Root.State.kakaoModel?.data?.isRefreshTokenExpires == true {
                                        send(.view(.auth(.login(.async(.kakaoLogin)))))
                                    }
                                }
                                print("epdlx \(Root.State.kakaoModel?.data?.isRefreshTokenExpires)")
                                
                                if Root.State.kakaoModel?.data?.isRefreshTokenExpires == true {
                                    send(.view(.auth(.login(.async(.kakaoLogin)))))
                                }
                                
                                if Root.State.kakaoModel?.data?.accessToken == accessToken {
                                    if ((Root.State.kakaoModel?.data?.accessToken?.isEmpty) != nil && Root.State.kakaoModel?.data?.isExpires != true) {
                                        send(.view(.changeScene(.homeRoot(.init()))))
                                    } else {
                                        send(.view(.changeScene(.auth(.init()))))
                                    }
                                }
                            }
                            
                        case "apple":
                            break
                        case "google":
                            break
                        default:
                            break
                        }
                    }
              
                case let .handleRefreshToken(refreshToken):
                    return .run { @MainActor  send in
                        send(.view(.auth(.login(.async(.refreshTokenRequest(refreshToken: refreshToken))))))
                        try await self.clock.sleep(for: .seconds(0.3))
                        send(.view(.auth(.login(.async(.loginWIthKakao)))))
                    }
                    
                case .handleKakaoLogin:
                    return .run { @MainActor  send in
                        send(.view(.auth(.login(.async(.loginWIthKakao)))))
                    }
                    
                case .kakaoLoginApiResponse(let data):
                    switch data {
                    case .success(let ResponseData):
                        @Shared(.inMemory("isLogOut")) var isLogOut: Bool = false
                        @Shared(.inMemory("isDeleteUser")) var isDeleteUser: Bool = false
                        @Shared(.inMemory("isChangeProfile")) var isChangeProfile: Bool = false
                        Root.State.kakaoModel = ResponseData
                        isLogOut = false
                        isDeleteUser = false
                        isChangeProfile = false
                    case .failure(let error):
                        Log.network("카카오 로그인 에러", error.localizedDescription)
                        
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
                                
                                if responseData.data?.isExpires == true && responseData.data?.isRefreshTokenExpires == true {
                                    send(.async(.refreshTokenRequest(refreshToken: responseData.data?.refreshToken ?? "")))
                                    
                                }
                            }
                            
                        case .failure(let error):
                            send(.async(.kakaoLoginApiResponse(.failure(CustomError.map(error)))))
                        }
                    }
                    
                case .checkUserVerfiy:
                    return .run { @MainActor send in
                        let checkUserVerifyResult = await Result {
                            try await authUseCase.checkUserVerify()
                        }
                        
                        switch checkUserVerifyResult {
                        case .success(let checkUserVerifyResult):
                            if let responseData = checkUserVerifyResult {
                                send(.async(.checkUserVerfiyResponse(.success(responseData))))
                                
                                send(.async(.loginWIthKakao))
                            }
                        case .failure(let error):
                            send(.async(.checkUserVerfiyResponse(.failure(CustomError.tokenError(error.localizedDescription)))))
                        }
                    }
                    
                case .checkUserVerfiyResponse(let result):
                    switch result{
                    case .success(let ResponseData):
                        Root.State.checkUserVerifyModel = ResponseData
                        
                    case .failure(let error):
                        Log.network("토큰 에러", error.localizedDescription)
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
                        Root.State.refreshTokenModel = refreshTokenData
                        Log.network("리프레쉬 토큰 발급", refreshTokenData)
                        Log.network("refershToken", refreshTokenData)
                        try? Keychain().set(Root.State.refreshTokenModel?.data?.refreshToken ?? "", key: "REFRESH_TOKEN")
                        try? Keychain().set(Root.State.refreshTokenModel?.data?.accessToken ?? "", key: "ACCESS_TOKEN")
                        
                    case .failure(let error):
                        Log.network("리프레쉬 토큰 발급 에러", error.localizedDescription)
                    }
                    return .none
                    
                }
                
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                    
                }
            }
        }
        .ifCaseLet(\.homeRoot, action: \.view.homeRoot) {
            HomeRoot()
        }
        .ifCaseLet(\.auth, action: \.view.auth) {
            Auth()
        }
        .ifCaseLet(\.signUpPAgging, action: \.view.signupPaging) {
            SignUpPaging()
        }
        .ifCaseLet(\.profile, action: \.view.profile) {
            Profile()
        }
    }
}

