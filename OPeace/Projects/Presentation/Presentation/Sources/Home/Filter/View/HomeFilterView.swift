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
                VStack(spacing: 12) {
                    Spacer()
                        .frame(height: 32)
                    
                    if let jobCategories = store.jsobListModel?.data?.data {
                        ForEach(jobCategories, id: \.self) { jobCategory in
                            HStack {
                                Text(jobCategory)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .pretendardFont(family: .Regular, size: 20)
                                    .padding(.horizontal, 32)
                                
                                Spacer()
                            }
                            .frame(height: 48)
                            .onTapGesture {
                                self.closeModalAction(jobCategory)
                            }
                            
                        }
                    }
                    if let generations = store.generationListModel?.data?.data {
                        ForEach(generations, id: \.self) { generation in
                            HStack {
                                Text(generation)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .pretendardFont(family: .Regular, size: 20)
                                    .padding(.horizontal, 32)
                                
                                Spacer()
                            }
                            .frame(height: 48)
                            .onTapGesture {
                                self.closeModalAction(generation)
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
//            store.send(.async(.fetchListByFilterEnum(self.filterType)))
        }
    }
}
