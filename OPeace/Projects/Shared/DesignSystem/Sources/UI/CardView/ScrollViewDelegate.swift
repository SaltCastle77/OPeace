//
//  ScrollViewDelegate.swift
//  DesignSystem
//
//  Created by 서원지 on 8/25/24.
//
//import UIKit
//import SwiftUI
//
//class ScrollViewDelegate<Content: View, T>: NSObject, UIScrollViewDelegate {
//    var parent: FlippableCardView<Content, T>
//    var itemHeight: CGFloat
//
//    init(parent: FlippableCardView<Content, T>, itemHeight: CGFloat) {
//        self.parent = parent
//        self.itemHeight = itemHeight
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        // Target content offset where the scroll will naturally stop
//        let targetY = targetContentOffset.pointee.y
//        
//        // Calculate the nearest item index
//        let nearestIndex = round(targetY / itemHeight)
//        
//        // Calculate the exact Y position to snap to
//        let newOffsetY = nearestIndex * itemHeight
//        
//        // Set the target content offset to snap without animation
//        targetContentOffset.pointee = CGPoint(x: 0, y: newOffsetY)
//        
//        // Optional adjustments to remove any content inset effects
//        scrollView.contentInset = .zero
//        scrollView.scrollIndicatorInsets = .zero
//        
//        // Update the current page index for other internal logic
//        DispatchQueue.main.async {
//            self.parent.currentPage = Int(nearestIndex)
//        }
//    }
//}
