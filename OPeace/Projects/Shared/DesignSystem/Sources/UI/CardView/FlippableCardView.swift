//
//  FlippableCardView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/24/24.

import SwiftUI
import SwiftUIIntrospect
import ComposableArchitecture

public struct FlippableCardView<Content: View, T>: View {
  @Environment(\.scenePhase) var scenePhase
  var data: [T]
  let content: (T) -> Content
  let onAppearLastItem: (() -> Void)?
  let onItemAppear: ((T) -> Void)?
  let shouldSaveState: Bool
  
  @Shared(.appStorage("lastViewedPage")) private var lastViewedPage: Int = 0
  @GestureState private var dragOffset: CGFloat = 0
  @State private var currentPage: Int = 0
  @State private var isScrolling: Bool = false
  @State private var dataCount: Int = 0
  
  public init(
    data: [T],
    shouldSaveState: Bool = true,
    onAppearLastItem: (() -> Void)? = nil,
    onItemAppear: ((T) -> Void)? = nil,
    content: @escaping (T) -> Content
  ) {
    self.data = data
    self.shouldSaveState = shouldSaveState
    self.content = content
    self.onAppearLastItem = onAppearLastItem
    self.onItemAppear = onItemAppear
    self._dataCount = State(initialValue: data.count)
  }
  
  public var body: some View {
    GeometryReader { geometry in
      ScrollViewReader { scrollViewProxy in
        ScrollView(.vertical, showsIndicators: false) {
          LazyVStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
              content(data[index])
                .frame(width: geometry.size.width)
                .background(Color.clear)
                .scrollTargetLayout()
                .id(index)
                .onAppear {
                  if !isScrolling {
                    handleItemAppear(index: index, item: data[index])
                  }
                  if index == data.indices.last {
                    onAppearLastItem?()
                  }
                }
              
              Spacer()
                .frame(height: index == data.indices.last ? UIScreen.main.bounds.height * 0.27 : 0)
            }
          }
          .gesture(DragGesture()
            .updating($dragOffset) { value, state, _ in
              state = value.translation.height
            }
            .onChanged { value in
              isScrolling = true
            }
            .onEnded { value in
              isScrolling = false
              let translation = value.translation.height
              let predictedEndTranslation = value.predictedEndTranslation.height
              let threshold: CGFloat = 50
              
              var newIndex = currentPage
              
              if predictedEndTranslation < -threshold {
                // 위로 스크롤
                newIndex = min(currentPage + 1, data.count - 1)
              } else if predictedEndTranslation > threshold {
                // 아래로 스크롤
                newIndex = max(currentPage - 1, 0)
              }
              
              updateCurrentPage(newIndex, with: scrollViewProxy)
            })
        }
        .scrollIndicators(.hidden)
        .onAppear {
          if shouldSaveState {
            currentPage = min(lastViewedPage, data.count - 1)
          } else {
            currentPage = 0
          }
          updateCurrentPage(currentPage, with: scrollViewProxy)
        }
        .onDisappear {
          if shouldSaveState {
            lastViewedPage = currentPage
          }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
          switch newValue {
          case .active:
            if shouldSaveState {
              currentPage = min(lastViewedPage, data.count - 1)
            } else {
              currentPage = 0
            }
            updateCurrentPage(currentPage, with: scrollViewProxy)
          case .background, .inactive:
            if shouldSaveState {
              lastViewedPage = 0
            }
          @unknown default:
            lastViewedPage = 0
          }
        }
        .onChange(of: data.count) { oldValue, newValue in
          if newValue != dataCount {
            // 현재 페이지가 데이터 수보다 크면 마지막 페이지로 이동
            if currentPage >= newValue {
              currentPage = max(0, newValue - 1)
            }
            if shouldSaveState {
              lastViewedPage = currentPage
            }
            updateCurrentPage(currentPage, with: scrollViewProxy)
            dataCount = newValue
          }
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
  
  private func handleItemAppear(index: Int, item: T) {
    guard index >= 0, index < data.count, index == currentPage else { return }
    onItemAppear?(item)
  }
  
  private func updateCurrentPage(_ index: Int, with scrollViewProxy: ScrollViewProxy) {
    guard index >= 0, index < data.count else { return }
    currentPage = index
    if shouldSaveState {
      lastViewedPage = index
    }
    scrollToCenter(scrollViewProxy: scrollViewProxy, index: index)
    handleItemAppear(index: index, item: data[index])
  }
  
  private func scrollToCenter(scrollViewProxy: ScrollViewProxy, index: Int) {
    guard index >= 0, index < data.count else { return }
    withAnimation(.easeInOut(duration: 0.3)) {
      scrollViewProxy.scrollTo(index, anchor: .center)
    }
  }
}

