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
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Image(asset: .arrowLeft)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .rotationEffect(.degrees(-90))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.gray500)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .overlay(
                RoundedRectangle(cornerRadius: 20.0)
                    .stroke(Color.gray400, lineWidth: 1.0)
            )
        }
    }
}

