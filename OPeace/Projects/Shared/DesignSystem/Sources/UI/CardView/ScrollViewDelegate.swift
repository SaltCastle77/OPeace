//
//  ScrollViewDelegate.swift
//  DesignSystem
//
//  Created by 서원지 on 8/25/24.
//

//import UIKit
//
//class ScrollViewDelegate<T>: NSObject, UIScrollViewDelegate {
//    var parent: FlippableCardView
//    var itemHeight: CGFloat
//
//    init(parent: FlippableCardView, itemHeight: CGFloat) {
//        self.parent = parent
//        self.itemHeight = itemHeight
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let targetY = targetContentOffset.pointee.y
//        let nearestIndex = round(targetY / itemHeight)
//        let newOffsetY = nearestIndex * itemHeight
//        targetContentOffset.pointee = CGPoint(x: 0, y: newOffsetY)
//        
//        DispatchQueue.main.async {
//            self.parent.currentPage = Int(nearestIndex)
//        }
//    }
//}
//
//
