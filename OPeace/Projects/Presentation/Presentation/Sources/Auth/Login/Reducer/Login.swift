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
    public enum AsyncAction: Equatable {
        
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presnetAgreement
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {      
            case .view(let View):
                switch View {
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
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

