//
//  RootView.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//

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
        Text("Root")
    }
}
