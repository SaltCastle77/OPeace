//
//  OnBoardingFirst.swift
//  Presentation
//
//  Created by 서원지 on 7/30/24.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct OnBoardingFirst {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var onBoardingFirstTilte = "고민 주제에"
        var onBoardingFirstSubTilte = "투표해 주세요!"
        var presntNextViewButtonTitle = "다음"
        public init() {}
    }
    
    public enum Action: Equatable {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

