//
//  SignUpAgreementFeature.swift
//  Feature
//
//  Created by 염성훈 on 2/24/24.
//  Copyright © 2024 Yeom. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SignUpAgreementFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case signUpNameButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signUpNameButtonTapped:
                return .none
            default:
                return .none
            }
        }
    }
    
}
