//
//  RootView.swift
//  Presentation
//
//  Created by 서원지 on 8/1/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture

public struct RootView: View {
    @Bindable var store: StoreOf<Root>
    
    public init(
        store: StoreOf<Root>
    ) {
        self.store = store
    }
    
    public var body: some View {
        SwitchStore(store) { state in
            switch state {
                
            case .homeRoot:
                if let store = store.scope(state: \.homeRoot, action: \.view.homeRoot) {
                    HomeRootView(store: store)
                }
         
            case .auth:
                if let store = store.scope(state: \.auth, action: \.view.auth) {
                    AuthView(store: store)
                }
                
            default:
                if let store = store.scope(state: \.auth, action: \.view.auth) {
                    AuthView(store: store)
                }
                
            }
               
        }
        .onAppear {
            store.send(.async(.autoLogin))
        }
    }
}


