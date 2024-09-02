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
    
    public var body: some View {
        Button(action: action) {
            //넓이를 이렇게 넣어줘야한다. overlay로 넣으면 제대로 넓이를 잡지 못함.
            HStack(spacing: 4) {
                Text(title)
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(Color.gray200)
                
                Image(asset: .arrowLeft)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .rotationEffect(.degrees(-90))
            }
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .stroke(Color.gray400, lineWidth: 1.0)
                    .fill(Color.gray500)
            )
        }
    }
    
    public init(
        action: @escaping () -> Void,
        title: String
        )
    {
        self.title = title
        self.action = action
    }
}
