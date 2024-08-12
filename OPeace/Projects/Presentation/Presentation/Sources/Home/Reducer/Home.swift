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
        
        var profileImage: String = "person.fill"
        var profile = Profile.State()
        @Shared var isLogOut: Bool
        @Shared var isDeleteUser: Bool
        @Shared var isLookAround: Bool
        @Shared var isChangeProfile: Bool
        @Presents var destination: Destination.State?
        var loginTiltle: String = "로그인을 해야 다른 기능을 사용하실 수 있습니다. "
        var floatingText: String = ""
        
        public init(
            isLogOut: Bool = false,
            isDeleteUser: Bool = false,
            isLookAround: Bool = false,
            isChangeProfile: Bool = false
        ) {
            self._isLogOut = Shared(wrappedValue: isLogOut, .inMemory("isLogOut"))
            self._isDeleteUser = Shared(wrappedValue: isDeleteUser, .inMemory("isDeleteUser"))
            self._isLookAround = Shared(wrappedValue: isLookAround, .inMemory("isLookAround"))
            self._isChangeProfile = Shared(wrappedValue: isChangeProfile, .inMemory("isChangeProfile"))
        }
        
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
        case floatingPopUP(FloatingPopUp)
        
    }
    
    //MARK: - ViewAction
//    @CasePathable
    public enum View {
        case appaerProfiluserData
        case prsentLoginPopUp
        case presntFloatintPopUp
        case closePopUp
        case timeToCloseFloatingPopUp
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
    
    @Dependency(\.continuousClock) var clock
    
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
                    
                    
                case .presntFloatintPopUp:
                    state.destination = .floatingPopUP(.init())
                    return .none
                    
                case .timeToCloseFloatingPopUp:
                    return .run { send in
                        try await clock.sleep(for: .seconds(1.5))
                        await send(.view(.closePopUp))
                    }
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

