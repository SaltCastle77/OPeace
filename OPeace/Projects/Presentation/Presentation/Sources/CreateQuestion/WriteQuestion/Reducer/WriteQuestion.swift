//
//  WriteQuestion.swift
//  Presentation
//
//  Created by 서원지 on 8/14/24.
//

import Foundation
import ComposableArchitecture

import Utill
import SwiftUI
import DesignSystem

@Reducer
public struct WriteQuestion {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("createQuestionEmoji")) var selectEmojiText: String = ""
        @Shared(.inMemory("createQuestionTitle")) var isWriteTextEditor: String = ""
        
        var isSelectEmoji: Bool = false
        var isInuputEmoji: Bool = false
        var emojiImage: Image? = nil
        var presntNextViewButtonTitle: String = "다음"
        var enableButton: Bool = false

        
        @Presents var destination: Destination.State?
        
        public init() {}
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
    @Reducer(state: .equatable)
    public enum Destination {
        case floatingPopUP(FloatingPopUp)
        
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
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
        case presntWriteAnswer
        
    }
    
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .binding(\.selectEmojiText):
                return .none
                
            case  .binding(\.isWriteTextEditor):
                return .none
                
            case .destination(_):
                return .none
                
            case .view(let View):
                switch View {
                case .presntFloatintPopUp:
                    state.destination = .floatingPopUP(.init())
                    return .none
                    
                case .closePopUp:
                    state.destination = nil
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
                case .presntWriteAnswer:
                    return .none
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
