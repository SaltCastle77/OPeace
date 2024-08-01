//
//  OnBoadingSecond.swift
//  Presentation
//
//  Created by 서원지 on 7/30/24.
//

import Foundation
import ComposableArchitecture
import Model

@Reducer
public struct OnBoadingSecond {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var onBoardingSecondTilte = "투표 후 세대별 결과를"
        var onBoardingSecondSubTilte = "볼 수 있어요!"
        var presntNextViewButtonTitle = "다음"
        var activeMenu: OnBoardingTab = .onBoardingSecond
        public init() {}
    }
    
    public enum Action: Equatable {
        case switchTab
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .switchTab:
                state.activeMenu = .onBoardingLast
                return .none
                
            }
        }
    }
}

