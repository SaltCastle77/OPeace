//
//  FloatingPopUp.swift
//  DesignSystem
//
//  Created by 서원지 on 8/4/24.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct FloatingPopUp {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
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

