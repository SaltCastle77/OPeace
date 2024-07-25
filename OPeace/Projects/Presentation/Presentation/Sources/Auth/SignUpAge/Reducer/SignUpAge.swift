//
//  SignUpAge.swift
//  Presentation
//
//  Created by 서원지 on 7/26/24.
//

import Foundation
import ComposableArchitecture

import Utill
import SwiftUI
import DesignSystem

@Reducer
public struct SignUpAge {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        var selectedTab = 1
        var totalTabs = 3
        var signUpAgeTitle: String = "나이 입력"
        var signUpAgeSubTitle: String = "출생 연도를  알려주세요"
         var signUpAgeDisplay = ""
        var signUpAgeDisplayColor: Color = Color.gray500
        var checkGenerationTextColor: Color = Color.gray500
        var checkGenerationText: String = "기타세대"
        var isErrorGenerationText: String = ""
        var presntNextViewButtonTitle = "다음"
        var enableButton: Bool = false
        var signUpName: String? = nil
        
        public init(
            signUpName: String? = nil
        ) {
            self.signUpName = signUpName
        }
    }
    
    public enum Action: ViewAction, FeatureAction , BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }

    @CasePathable
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
    
    }
    
                        
    
                        
                        
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .binding(\.signUpAgeDisplay):
                return .none
                
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
                    
                }
                
            default:
                return .none
            }
        }
    }
}

