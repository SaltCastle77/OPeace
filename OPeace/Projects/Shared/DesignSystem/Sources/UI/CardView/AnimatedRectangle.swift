//
//  AnimatedRectangle.swift
//  DesignSystem
//
//  Created by 서원지 on 9/3/24.
//

import SwiftUI

struct AnimatedRectangle: View {
    let key: String
    let color: Color
    let targetWidth: CGFloat
    let offset: CGFloat
    let corners: UIRectCorner
    
    @State private var animatedWidth: CGFloat = 0
    @State private var timer: Timer?

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: animatedWidth, height: 48)
            .offset(x: offset)
            .clipShape(RoundedCornersShape(corners: corners, radius: 20))
            .onAppear {
                if animatedWidth == 0 {
                    animatedWidth = 0
                    startAnimation()
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
    }
    
    private func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            withAnimation(.linear(duration: 0.01)) {
                if animatedWidth < targetWidth {
                    animatedWidth += 1
                } else {
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }
}
