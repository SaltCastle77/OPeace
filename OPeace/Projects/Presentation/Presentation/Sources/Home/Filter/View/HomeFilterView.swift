//
//  HomeFilterView.swift
//  Presentation
//
//  Created by 염성훈 on 8/25/24.
//

import Foundation
import SwiftUI
import DesignSystem

import ComposableArchitecture
import Moya

public struct HomeFilterView: View {
    
    @Bindable var store: StoreOf<HomeFilter>
    
    public var body: some View {
        Text("hello")
    }
    
    public init(store: StoreOf<HomeFilter>) {
        self.store = store
    }
}
