//
//  FlippableCardView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/24/24.

import SwiftUI
import SwiftUIIntrospect

public struct FlippableCardView<Content: View, T>: View {
    @Environment(\.scenePhase) var scenePhase
    var data: [T]
    let content: (T) -> Content
    let onAppearLastItem: (() -> Void)?
    let onItemAppear: ((T) -> Void)?
    let shouldSaveState: Bool

    @AppStorage("lastViewedPage") private var lastViewedPage: Int = 0
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
                ScrollView(.vertical) {
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
                            state = value.translation.height * 0.2
                        }
                        .onChanged { _ in
                            isScrolling = true
                        }
                        .onEnded { value in
                            isScrolling = false
                            let velocity = value.predictedEndLocation.y - value.startLocation.y
                            let nearestIndex = calculateNearestIndex(
                                geometry: geometry,
                                currentPage: currentPage,
                                velocity: velocity
                            )
                            updateCurrentPage(nearestIndex, with: scrollViewProxy)
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
                .onChange(of: scenePhase) { newValue in
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
                            lastViewedPage = currentPage
                        }
                    @unknown default:
                        lastViewedPage = 0
                    }
                }
                .onChange(of: data.count) { newCount in
                    if newCount != dataCount {
                        currentPage = 0
                        if shouldSaveState {
                            lastViewedPage = 0
                        }
                        updateCurrentPage(currentPage, with: scrollViewProxy)
                        dataCount = newCount
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
    
    private func calculateNearestIndex(
        geometry: GeometryProxy,
        currentPage: Int,
        velocity: CGFloat
    ) -> Int {
        let threshold: CGFloat = 30
        if velocity > threshold {
            return max(currentPage - 1, 0)
        } else if velocity < -threshold {
            return min(currentPage + 1, data.count - 1)
        }
        return currentPage
    }
    
    private func scrollToCenter(scrollViewProxy: ScrollViewProxy, index: Int) {
        guard index >= 0, index < data.count else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)) {
            scrollViewProxy.scrollTo(index, anchor: .center)
        }
    }
}

