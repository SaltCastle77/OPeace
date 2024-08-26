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
        VStack {
            ScrollView {
                VStack(spacing: 12) {
                    if let jobCategories = store.jsobListModel?.data?.data {
                        ForEach(jobCategories, id: \.self) { jobCategory in
                            Text(jobCategory)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .pretendardFont(family: .Regular, size: 20)
                                .padding(.horizontal, 15)
                                .onTapGesture {
//                                    self.store.send(.view(.))
                                }
                        }
                    }
                }
                .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.gray500)
        .onAppear {
            store.send(.async(.fetchJobList))
        }
    }
    
    public init(store: StoreOf<HomeFilter>) {
        self.store = store
    }
}
