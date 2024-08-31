//
//  CustomTitleNaviagionBar.swift
//  DesignSystem
//
//  Created by 서원지 on 8/1/24.
//

import SwiftUI

public struct CustomTitleNaviagionBackButton: View {
    var buttonAction: () -> Void = { }
    var title: String
    
    public init(
        buttonAction: @escaping () -> Void,
        title: String
    ) {
        self.buttonAction = buttonAction
        self.title = title
    }
    
    public var body: some View {
        HStack {
            Spacer()
                .frame(width: 19)
            
            Image(asset: .arrowLeft)
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 20)
                .foregroundStyle(Color.gray400)
                .onTapGesture {
                    buttonAction()
                }
            
            Spacer()
            
            Text(title)
                .pretendardFont(family: .SemiBold, size: 20)
                .foregroundStyle(Color.gray200)
                .offset(x: -10)
            
            Spacer()

            
        }
    }
}
