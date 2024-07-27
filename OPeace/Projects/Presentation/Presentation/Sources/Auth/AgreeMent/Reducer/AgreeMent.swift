//
//  AgreeMent.swift
//  Presentation
//
//  Created by 서원지 on 7/22/24.
//

import Foundation
import ComposableArchitecture

import Utill

@Reducer
public struct AgreeMent {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var agreeMentTilteText: String = "이용 약관 동의"
        var agreeMentSubTitleText: String = "원활한 서비스 이용을 위해 동의해 주세요"
        var allAgreeMentText: String =  "약관 전체 동의"
        var ageAgreeCheckTitle: String =  "만 14세 이상입니다."
        var serviceAgreeCheckTitle: String =  "서비스 이용 약관"
        var privacyAgreeCheckTitle: String =  "개인정보 처리방침"
        var nextButtonTitle: String = "다음"
        
        var allAgreeCheckState: Bool = false
        var ageAgreeCheckState: Bool = false
        var serviceAgreeCheckState: Bool = false
        var privacyAgreeCheckState: Bool = false
        var enableNextButton = false
        
    }
    
    public enum Action: ViewAction ,FeatureAction, BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
  
    
    //MARK: - ViewAction
    public enum View {
        case allAgreeCheckTapped
        case ageAgreeCheckTappd
        case serviceAgreeCheckTapped
        case privacyAgreeCheckTapped
        
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
       
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntSignUpName
        case presntPrivacyAgreeCheckTapped
        case presntServiceAgreeCheckTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .view(let View):
                switch View {
                case .allAgreeCheckTapped:
                    let newState = !state.allAgreeCheckState
                    state.allAgreeCheckState = newState
                    state.ageAgreeCheckState = newState
                    state.serviceAgreeCheckState = newState
                    state.privacyAgreeCheckState = newState
                    state.enableNextButton = newState
                    return .none
                    
                case .ageAgreeCheckTappd:
                    state.ageAgreeCheckState.toggle()
                    let enableNextButton = self.checkEnableNextButton(
                        age: state.ageAgreeCheckState,
                        service: state.serviceAgreeCheckState,
                        privacy: state.privacyAgreeCheckState
                    )
                    state.enableNextButton = enableNextButton
                    state.allAgreeCheckState = enableNextButton
                    return .none
                    
                case .serviceAgreeCheckTapped:
                    state.serviceAgreeCheckState.toggle()
                    let enableNextButton = self.checkEnableNextButton(
                        age: state.ageAgreeCheckState,
                        service: state.serviceAgreeCheckState,
                        privacy: state.privacyAgreeCheckState
                    )
                    state.enableNextButton = enableNextButton
                    state.allAgreeCheckState = enableNextButton
                    return .none
                    
                case .privacyAgreeCheckTapped:
                    state.privacyAgreeCheckState.toggle()
                    let enableNextButton = self.checkEnableNextButton(
                        age: state.ageAgreeCheckState,
                        service: state.serviceAgreeCheckState,
                        privacy: state.privacyAgreeCheckState
                    )
                    state.enableNextButton = enableNextButton
                    state.allAgreeCheckState = enableNextButton
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
                case .presntSignUpName:
                    return .none
                    
                case .presntPrivacyAgreeCheckTapped:
                    return .none
                    
                case .presntServiceAgreeCheckTapped:
                    return .none
                }
            }
            
        }
    }
    
    private func checkEnableNextButton(
        age: Bool,
        service: Bool,
        privacy:  Bool) -> Bool {
        if age && service && privacy {
            return true
        } else {
            return false
        }
    }
}

