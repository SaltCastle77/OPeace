//
//  DotBarView.swift
//  DesignSystem
//
//  Created by 서원지 on 7/24/24.
//

import Foundation
import SwiftUI
import Model

public struct DotBarView: View {
    @Binding var activeIndex: SignUpTab
//    var totalDots: Int

    public init(
        activeIndex: Binding<SignUpTab>
//        totalDots: Int
    ) {
        self._activeIndex = activeIndex
//        self.totalDots = totalDots
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(SignUpTab.allCases, id: \.self) { index in
                if index == activeIndex {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.basicPrimary)
                        .frame(width: 18, height: 6)
                        .padding(2)
                        .background(Circle().fill(Color.green).blur(radius: 4))
                        .onTapGesture {
                            activeIndex = index
                        }
                } else {
                    Circle()
                        .fill(Color.gray400)
                        .frame(width: 6, height: 6)
                        .onTapGesture {
                            activeIndex = index
                        }
                }
            }
        }
        .padding()
        .cornerRadius(10)
    }
}
