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
    
    @AppStorage("lastViewedPage") private var lastViewedPage: Int = 0
    @State private var currentPage: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    public init(
        data: [T],
        onAppearLastItem: (() -> Void)? = nil,
        content: @escaping (T) -> Content
    ) {
        self.data = data
        self.content = content
        self.onAppearLastItem = onAppearLastItem
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollViewProxy in
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(data.indices, id: \.self) { index in
                            content(data[index])
                                .frame(width: geometry.size.width, height: 520)
                                .background(Color.clear)
                                .scrollTargetLayout()
                                .id(index)
                                .onAppear {
                                    if index == data.indices.last {
                                        onAppearLastItem?()
                                    }
                                }
                            
                            Spacer()
                                .frame(height: index == data.indices.last ? UIScreen.main.bounds.height * 0.25 : 5)
                        }
                    }
                    .gesture(DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.height * 0.2 // Dampen the drag effect
                        }
                        .onEnded { value in
                            // Determine the nearest index based on drag velocity and position
                            let velocity = value.predictedEndLocation.y - value.startLocation.y
                            let nearestIndex = calculateNearestIndex(
                                geometry: geometry,
                                currentPage: currentPage,
                                velocity: velocity
                            )
                            currentPage = nearestIndex
                            lastViewedPage = nearestIndex // Save the current page as the last viewed page
                            scrollToCenter(scrollViewProxy: scrollViewProxy, index: nearestIndex)
                        })
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
                .onAppear {
                    currentPage = min(lastViewedPage, data.count - 1)
                    scrollToCenter(scrollViewProxy: scrollViewProxy, index: currentPage)
                }
                .onChange(of: scenePhase) { oldValue, newValue in
                    switch newValue {
                    case .active:
                        lastViewedPage = lastViewedPage
                    case .background:
                        lastViewedPage = 0
                    case .inactive:
                        lastViewedPage = 0
                    @unknown default:
                        lastViewedPage = 0
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    private func calculateNearestIndex(
        geometry: GeometryProxy,
        currentPage: Int,
        velocity: CGFloat
    ) -> Int {
        let threshold: CGFloat = 30 // Minimum velocity needed to trigger a scroll change
        if velocity > threshold {
            return max(currentPage - 1, 0)
        } else if velocity < -threshold {
            return min(currentPage + 1, data.count - 1)
        }
        return currentPage
    }
    
    
    private func scrollToCenter(scrollViewProxy: ScrollViewProxy, index: Int) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)) {
            scrollViewProxy.scrollTo(index, anchor: .center)
        }
    }
}



struct ScrollEffectModifier: ViewModifier {
    let index: Int
    let currentPage: Int
    let dragOffset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(y: calculateOffset())
    }
    
    private func calculateOffset() -> CGFloat {
        if index == currentPage - 1 && dragOffset > 0 {
            return min(dragOffset / 5, 30)
        }
        return 0
    }
}
