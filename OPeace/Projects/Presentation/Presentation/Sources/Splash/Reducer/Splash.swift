//
//  Splash.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import ComposableArchitecture
import DesignSystem

import Utill
import Networkings

@Reducer
public struct Splash {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var applogoImage: ImageAsset = .spalshLogo
        var backgroundmage: ImageAsset = .backGroud
        
        var checkUserVerifyModel: CheckUserVerifyModel? = nil
        var refreshTokenModel: RefreshModel? = nil
        
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        
    }
    
    
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case refreshTokenResponse(Result<RefreshModel, CustomError>)
        case refreshTokenRequest(refreshToken: String)
        
        case checkUserVerfiy
        case checkUserVerfiyResponse(Result<CheckUserVerifyModel , CustomError>)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntMain
        case presntLogin
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .binding(_):
                return .none
                
                
            case .view(let View):
                switch View {
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                case .refreshTokenRequest(let refreshToken):
                    return .run { send in
                        let refreshTokenResult = await Result {
                            try await authUseCase.requestRefreshToken(refreshToken: refreshToken)
                        }
                        
                        switch refreshTokenResult {
                        case .success(let refreshTokenData):
                            if let refreshTokenData = refreshTokenData {
                                await send(.async(.refreshTokenResponse(.success(refreshTokenData))))
                                
                                if refreshTokenData.data?.refreshToken?.isEmpty != nil && refreshTokenData.data?.accessToken?.isEmpty != nil {
                                    await send(.navigation(.presntMain))
                                }
                            }
                            
                        case .failure(let error):
                            await send(.async(.refreshTokenResponse(.failure(CustomError.tokenError(error.localizedDescription)))))
                        }
                    }
                    
                case .refreshTokenResponse(let result):
                    switch result {
                    case .success(let refreshTokenData):
                        state.refreshTokenModel = refreshTokenData
                        UserDefaults.standard.set(state.refreshTokenModel?.data?.refreshToken ?? "", forKey: "REFRESH_TOKEN")
                        UserDefaults.standard.set(state.refreshTokenModel?.data?.accessToken ?? "", forKey: "ACCESS_TOKEN")
                    case .failure(let error):
                        Log.error("토큰 재발급 실패", error.localizedDescription)
                    }
                    return .none
                    
               
                case .checkUserVerfiy:
                    return .run { send in
                        let checkUserVerifyResult = await Result {
                            try await authUseCase.checkUserVerify()
                        }
                        
                        switch checkUserVerifyResult {
                        case .success(let checkUserVerifyData):
                            if let checkUserVerifyData = checkUserVerifyData {
                                await send(.async(.checkUserVerfiyResponse(.success(checkUserVerifyData))))
                                
                                if checkUserVerifyData.data?.status == true {
                                    await send(.navigation(.presntMain))
                                } else {
                                    let refreshToken = UserDefaults.standard.string(forKey: "REFRESH_TOKEN") ?? ""
                                    await send(.async(.refreshTokenRequest(refreshToken: refreshToken)))

                                }
                            }
                        case .failure(let error):
                            await send(.async(.checkUserVerfiyResponse(.failure(CustomError.tokenError(error.localizedDescription)))))
                            
                            await send(.navigation(.presntLogin))
                            
                        }
                    }
                    
                case .checkUserVerfiyResponse(let result):
                    switch result {
                    case .success(let userVerifyData):
                        state.checkUserVerifyModel = userVerifyData
                    case .failure(let error):
                        Log.error("토큰 재발급 실패", error.localizedDescription)
                    }
                    return .none
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
                    
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                case .presntMain:
                    return .none
                    
                case .presntLogin:
                    return .none
                }
            }
        }
    }
}


