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
        RoundedRectangle(cornerRadius: 15.0)
            .stroke(Color.gray400, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            .fill(Color.gray500)
            .frame(height: 40)
            .overlay {
                Text(title)
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(Color.gray200)
            }
            .onTapGesture {
                action()
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
