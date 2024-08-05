//
//  Home.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import Foundation
import ComposableArchitecture

import Utill
import KeychainAccess
import DesignSystem

@Reducer
public struct Home {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var profileImage: String = "person.fill"
        var profile = Profile.State()
        var isLogin = UserDefaults.standard.bool(forKey: "isLogOut")
        var isLookAround =  UserDefaults.standard.bool(forKey: "isLookAround")
        @Presents var destination: Destination.State?
        var loginTiltle: String = "로그인을 해야 다른 기능을 사용하실 수 있습니다. "
        
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
        case profile(Profile.Action)
        
        
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case customPopUp(CustomPopUp)
        case floatintPopUp(FloatingPopUp)
        
    }
    
    //MARK: - ViewAction
//    @CasePathable
    public enum View {
        case appaerProfiluserData
        case prsentLoginPopUp
        case presntFloatintPopUp
        case closePopUp
        case isLogoutCheckPopUp
    }
    
  
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
       
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntProfile
        case presntLogin
    
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
               
            
            case .view(let View):
                switch View {
                case .appaerProfiluserData:
                    return .run { @MainActor send in
                        send(.profile(.scopeFetchUser))
                    }
                           
                case .prsentLoginPopUp:
                    state.destination = .customPopUp(.init())
                    return .none
                    
                case .closePopUp:
                    state.destination = nil
                    return .none
                    
                case .isLogoutCheckPopUp:
                    guard let lastLogin = try? Keychain().get("LastLogin") else { return .none }
                    print("lastlogin: \(lastLogin)")
                    return .run { @MainActor send in
                        if !lastLogin.isEmpty {
                            send(.view(.presntFloatintPopUp))
                        }
                    }
                    
                case .presntFloatintPopUp:
                    state.destination = .floatintPopUp(.init())
                    return .none
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
                    
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                case .presntProfile:
                    return .run { @MainActor send in
                        send(.profile(.scopeFetchUser))
                    }
                    
                case .presntLogin:
                    return .none
                }
                
            default:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        Scope(state: \.profile, action: \.profile) {
            Profile()
        }
    }
}

