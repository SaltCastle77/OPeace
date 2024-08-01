//
//  ProfileView.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI
import DesignSystem

import ComposableArchitecture

public struct ProfileView: View {
    @Bindable var store: StoreOf<Profile>
    
    
    public init(store: StoreOf<Profile>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
        }
    }
}
