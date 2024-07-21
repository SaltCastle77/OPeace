//
//  Splash.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import ComposableArchitecture
import DesignSystem

@Reducer
public struct Splash {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var applogoImage: ImageAsset = .spalshLogo
        var backgroundmage: ImageAsset = .backGroud
    }
    
    public enum Action: Equatable {
        case presentRootView
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .presentRootView:
                return .none
            }
        }
    }
}


