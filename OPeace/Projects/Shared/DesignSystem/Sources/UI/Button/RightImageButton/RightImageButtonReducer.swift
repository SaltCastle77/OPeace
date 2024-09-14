//
//  RightImageButtonReducer.swift
//  DesignSystem
//
//  Created by 염성훈 on 9/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct RightImageButtonReducer {
    public init() {}
    
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: Equatable {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
                
            }
        }
    }
}
