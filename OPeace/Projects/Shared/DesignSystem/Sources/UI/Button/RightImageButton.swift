//
//  RightImageButtonView.swift
//  DesignSystem
//
//  Created by 염성훈 on 8/20/24.
//

import Foundation
import SwiftUI

public struct RightImageButton: View {
    let action: () -> Void
    let title: String
    
    public init(
        action: @escaping () -> Void,
        title: String
    ) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title.isEmpty ? " " : title) // Provide a space if title is empty to maintain structure
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(Color.gray200)
                    .fixedSize(horizontal: true, vertical: false) // Expand text horizontally without truncating
                
                Image(asset: .arrowLeft)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .rotationEffect(.degrees(-90))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .stroke(Color.gray400, lineWidth: 1.0)
                    .background(Color.gray500) // Ensure background color is filled properly
                    .clipShape(Capsule())
                    .frame(minWidth: 40, maxWidth: max(78, CGFloat(title.count) * 10), maxHeight: 40)
            )
        }
    }
}

