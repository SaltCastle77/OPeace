//
//  UINavigationController+gesture.swift
//  DesignSystem
//
//  Created by 서원지 on 7/20/24.
//

import UIKit
import SwiftUI

//extension UINavigationController: UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}
//
//struct CustomBackGestureModifier: ViewModifier {
//    let enableGesture: Bool
//    
//    func body(content: Content) -> some View {
//        content
//            .background(NavigationConfigurator { navigationController in
//                if enableGesture {
//                    navigationController.interactivePopGestureRecognizer?.delegate = navigationController 
//                } else {
//                    navigationController.interactivePopGestureRecognizer?.delegate = nil
//                }
//            })
//    }
//}
//
//public extension View {
//    func customBackGesture(enableGesture: Bool) -> some View {
//        self.modifier(CustomBackGestureModifier(enableGesture: enableGesture))
//    }
//}
//
//struct NavigationConfigurator: UIViewControllerRepresentable {
//    var configure: (UINavigationController) -> Void
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        UIViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if let navigationController = uiViewController.navigationController {
//            self.configure(navigationController)
//        }
//    }
//}
