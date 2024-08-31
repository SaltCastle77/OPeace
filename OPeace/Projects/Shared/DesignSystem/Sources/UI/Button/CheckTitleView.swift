//
//  CheckTitleView.swift
//  DesignSystem
//
//  Created by 서원지 on 7/22/24.
//

import SwiftUI

public struct CheckTitleView: View {
    private var action: () -> Void
    private var text: String
    private var isChecked: Bool
    var isAreemnetAll: Bool
    var isEssentialAgree: Bool
    var isActiveUnderline: Bool
    private var goWebView: () -> Void
    
    public init(
        action: @escaping () -> Void,
        goWebView: @escaping () -> Void,
        text: String,
        isChecked: Bool = false,
        isAreemnetAll: Bool = false,
        isEssentialAgree: Bool = false,
        isActiveUnderline: Bool = false
    ) {
        self.action = action
        self.text = text
        self.isChecked = isChecked
        self.isAreemnetAll = isAreemnetAll
        self.isEssentialAgree = isEssentialAgree
        self.isActiveUnderline = isActiveUnderline
        self.goWebView = goWebView
    }
    
   
    
    
    public var body: some View {
        VStack {
            HStack {
                Image(asset: isChecked ? .circleCheckFill : .circleCheck)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 0))
                
                if isEssentialAgree {
                    Text("(필수)\(text)")
                        .pretendardFont(family: .Regular, size: 16)
                        .foregroundStyle(Color.basicWhite)
                    
                } else if isActiveUnderline {
                    HStack {
                        Text("(필수)")
                            .pretendardFont(family: .Regular, size: 16)
                            .foregroundStyle(Color.basicWhite)
                        
                        Text("\(text)")
                            .pretendardFont(family: .Regular, size: 16)
                            .foregroundStyle(Color.basicWhite)
                            .underline(true, color: Color.basicWhite)
                    }
                    .onTapGesture {
                        goWebView()
                    }
                } else {
                    Text(text)
                        .pretendardFont(family: .Medium, size: 16)
                        .foregroundStyle(Color.basicWhite)
                }
                
                Spacer()
            }
            if isAreemnetAll {
                Spacer()
                    .frame(height: 20)
                
                Divider()
                    .background(Color.gray400)
                    .padding(.horizontal, 20)
            }
        }
//        .padding(.horizontal, 20)
        .onTapGesture {
            action()
        }
    }
}
