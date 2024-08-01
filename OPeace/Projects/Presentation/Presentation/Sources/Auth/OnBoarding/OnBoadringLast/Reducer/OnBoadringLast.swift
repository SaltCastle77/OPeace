//
//  OnBoadringLast.swift
//  Presentation
//
//  Created by 서원지 on 7/30/24.
//

import Foundation
import ComposableArchitecture
import Model

@Reducer
public struct OnBoadringLast {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var onBoardingLastTilte = "나의 고민글도"
        var onBoardingLastSubTilte = "작성해보세요!"
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

