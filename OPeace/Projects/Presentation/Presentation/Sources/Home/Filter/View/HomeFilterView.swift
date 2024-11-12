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
    @Binding var selectItem: String?

    public init(
        store: StoreOf<HomeFilter>,
        selectItem: Binding<String?>,
        closeModalAction: @escaping (String) -> Void
    ) {
        self.store = store
        self._selectItem = selectItem
        self.closeModalAction = closeModalAction
    }

    public var body: some View {
      ZStack {
        ZStack {
          Color.gray600
            .edgesIgnoringSafeArea(.all)
          
          VStack {
            ScrollView {
              VStack(spacing: 4) {
                Spacer()
                  .frame(height: 22)
                switch store.homeFilterTypeState {
                case .job:
                  if let jobCategories = store.jsobListModel?.data.content {
                    ForEach(jobCategories, id: \.self) { jobCategory in
                      filterListItem(title: jobCategory, isSelected: selectItem == jobCategory) {
                        selectItem = jobCategory
                        store.selectedItem = jobCategory
                        closeModalAction(jobCategory)
                      }
                    }
                  }
                case .generation:
                  if let generations = store.generationListModel?.data.content {
                    ForEach(generations, id: \.self) { generation in
                      filterListItem(title: generation, isSelected: selectItem == generation) {
                        selectItem = generation
                        store.selectedItem = generation
                        closeModalAction(generation)
                      }
                    }
                    Spacer()
                      .frame(height: 32)
                  }
                case .sorted:
                  ForEach([QuestionSort.recent, QuestionSort.popular], id: \.self) { sorted in
                    filterListItem(title: sorted.sortedKoreanString, isSelected: selectItem == sorted.sortedKoreanString) {
                      selectItem = sorted.sortedKoreanString
                      store.selectedItem = sorted.sortedKoreanString
                      closeModalAction(sorted.sortedKoreanString)
                    }
                  }
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
          .onAppear {
            store.send(.view(.tapSettintitem(store.homeFilterTypeState ?? .job)))
          }
        }
      }
    }
}

extension HomeFilterView {
  
  @ViewBuilder
  private func filterListItem(
      title: String,
      isSelected: Bool,
      completion: @escaping () -> Void
  ) -> some View {
      HStack {
          Text(title)
              .frame(maxWidth: .infinity, alignment: .leading)
              .pretendardFont(family: .Regular, size: 20)
              .foregroundColor(isSelected ? Color.basicPrimary : Color.basicWhite)
              .onTapGesture {
                  completion()
              }
      }
      .frame(height: 48)
      .padding(.horizontal, 32)
  }
}


