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
    @State private var scrollViewDelegate: ScrollViewDelegate<Content, T>? // Strong reference to delegate

    public init(
        data: [T],
        content: @escaping (T) -> Content
    ) {
        self.data = data
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 10) { // Spacing of 10 points between items
                    ForEach(data.indices, id: \.self) { index in
                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray500)
                                .frame(height: 530) // Set height to 530 points
                                .padding(.horizontal, 20)
                                .overlay(content(data[index])) // Custom content
                        }
                        .frame(width: geometry.size.width)
                    }
                }
            }
            .scrollTargetLayout()
            .introspect(.scrollView, on: .iOS(.v17, .v18), customize: { scrollView in
                let delegate = ScrollViewDelegate<Content, T>(parent: self, itemHeight: 540)
                scrollViewDelegate = delegate
                scrollView.delegate = delegate
                scrollView.alwaysBounceVertical = true
                scrollView.contentInsetAdjustmentBehavior = .automatic
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.decelerationRate = .fast
            })
        }
        .edgesIgnoringSafeArea(.all)
    }
}

class ScrollViewDelegate<Content: View, T>: NSObject, UIScrollViewDelegate {
    var parent: FlippableCardView<Content, T>
    var itemHeight: CGFloat

    init(parent: FlippableCardView<Content, T>, itemHeight: CGFloat) {
        self.parent = parent
        self.itemHeight = itemHeight
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetY = targetContentOffset.pointee.y
        let nearestIndex = round(targetY / itemHeight)
        let newOffsetY = nearestIndex * itemHeight
        targetContentOffset.pointee = CGPoint(x: 0, y: newOffsetY)
        
        DispatchQueue.main.async {
            self.parent.currentPage = Int(nearestIndex)
        }
    }
}
