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
import Model

public struct HomeFilterView: View {
    
    @Bindable var store: StoreOf<HomeFilter>
    private var closeModalAction: (String) -> Void
    private var filterType: HomeFilterEnum
    
    public init(
        store: StoreOf<HomeFilter>,
        filterType: HomeFilterEnum,
        closeModalAction: @escaping (String) -> Void
    ) {
        self.store = store
        self.closeModalAction = closeModalAction
        self.filterType = filterType
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 12) {
                    switch filterType {
                    case .job:
                        if let jobCategories = store.jsobListModel?.data?.data {
                            ForEach(jobCategories, id: \.self) { jobCategory in
                                Text(jobCategory)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .pretendardFont(family: .Regular, size: 20)
                                    .padding(.horizontal, 15)
                                    .onTapGesture {
                                        self.closeModalAction(jobCategory)
                                    }
                            }
                        }
                    case .generation:
                        Text("세대")
                    case .sorted(let sortedEnum):
                        Text("정렬")
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
}
