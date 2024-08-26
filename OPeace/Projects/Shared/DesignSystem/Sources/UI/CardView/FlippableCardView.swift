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

    @State var currentPage: Int = 0
    @State private var scrollViewDelegate: ScrollViewDelegate<Content, T>? = nil

    public init(
        data: [T],
        content: @escaping (T) -> Content
    ) {
        self.data = data
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    ForEach(data.indices, id: \.self) { index in
                        VStack {
                            content(data[index])
                            
                            if index == data.indices.last {
                                Spacer()
                                    .frame(height: UIScreen.screenHeight * 0.15)
                            } else {
                                Spacer()
                                    .frame(height: 10)
                            }
                        }
                        .frame(width: geometry.size.width)
                    }
                }
            }
            .scrollDisabled(data.count == 1)
            .scrollTargetLayout()
            .onAppear {
                if scrollViewDelegate == nil || data.count > 1 {
                    scrollViewDelegate = ScrollViewDelegate<Content, T>(parent: self, itemHeight: 520)
                }
            }
            .introspect(.scrollView, on: .iOS(.v17, .v18), customize: { scrollView in
                if let delegate = scrollViewDelegate {
                    scrollView.delegate = delegate
                    scrollView.alwaysBounceVertical = true
                    scrollView.contentInsetAdjustmentBehavior = .automatic
                    scrollView.showsVerticalScrollIndicator = false
                    scrollView.showsHorizontalScrollIndicator = false
                    scrollView.decelerationRate = .fast
                }
            })
        }
        .edgesIgnoringSafeArea(.all)
    }
}

