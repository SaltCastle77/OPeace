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
    
    public init(
        store: StoreOf<HomeFilter>,
        closeModalAction: @escaping (String) -> Void
    ) {
        self.store = store
        self.closeModalAction = closeModalAction
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 4) {
                    Spacer()
                        .frame(height: 22)
                    switch store.homeFilterTypeState {
                    case .job:
                        if let jobCategories = store.jsobListModel?.data?.data {
                            ForEach(jobCategories, id: \.self) { jobCategory in
                                  filterListItem(title: jobCategory) {
                                    closeModalAction(jobCategory)
                                }
                            }
                        }
                    case .generation:
                        if let generations = store.generationListModel?.data?.data {
                            ForEach(generations, id: \.self) { generation in
                                filterListItem(title: generation) {
                                    closeModalAction(generation)
                                }
                            }
                            
                            Spacer()
                                .frame(height: 32)
                        }
                    case .sorted:
                        Text("")
                    case .none:
                        Text("")
                    }
                    
                }
                .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
            .onAppear {
                UIScrollView.appearance().bounces = false
                
            }
        }
        .background(Color.gray500)

        .onAppear {
            store.send(.view(.tapSettintitem(store.homeFilterTypeState ?? .job)))
        }
    }
    
    @ViewBuilder
    private func filterListItem(
        title: String,
        completion: @escaping () -> Void
    ) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .pretendardFont(family: .Regular, size: 20)
                .foregroundStyle(Color.basicWhite)
                .onTapGesture {
                    completion()
                }
        }
        .frame(height: 48)
        .padding(.horizontal , 32)
    }
    
}
