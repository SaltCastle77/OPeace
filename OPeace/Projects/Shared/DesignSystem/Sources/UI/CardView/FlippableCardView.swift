//
//  FlippableCardView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/24/24.

import SwiftUI
import SwiftUIIntrospect

public struct FlippableCardView<Content: View, T>: View {
    var data: [T]
    let content: (T) -> Content
    let onAppearLastItem: (() -> Void)?
    
    @State var currentPage: Int = 0
    @State var scrollViewDelegate: ScrollViewDelegate<Content, T>? = nil
    
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
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: .zero) {
                    ForEach(data.indices, id: \.self) { index in
                        LazyVStack {
                            content(data[index])
                                .containerRelativeFrame(.horizontal)
                                .scrollTargetLayout()
                                .onAppear {
                                    if index == data.indices.last {
                                        onAppearLastItem?()
                                    }
                                }
                            
                            if index == data.indices.last {
                                Spacer()
                                    .frame(height: UIScreen.screenHeight * 0.15)
                            } else {
                                Spacer()
                                    .frame(height: 10)
                            }
                        }
                        .frame(width: geometry.size.width)
                        .scrollTargetLayout()
                    }
                }

            }
            .scrollDisabled(data.count == 1)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
//            .contentMargins(.vertical, 10)
            .onAppear {
                if scrollViewDelegate == nil || data.count > 1 {
                    scrollViewDelegate = ScrollViewDelegate<Content, T>(parent: self, itemHeight: 527)
                }
            }
            .introspect(.scrollView, on: .iOS(.v17, .v18), customize: { scrollView in
                if let delegate = scrollViewDelegate {
                    scrollView.delegate = delegate
                    scrollView.alwaysBounceVertical = true
                    scrollView.contentInsetAdjustmentBehavior = .never
                    scrollView.showsVerticalScrollIndicator = false
                    scrollView.showsHorizontalScrollIndicator = false
                    scrollView.decelerationRate = .fast
                    scrollView.contentInset = .zero
                    scrollView.scrollIndicatorInsets = .zero
                }
            })
        }
        .edgesIgnoringSafeArea(.all)
    }
}

