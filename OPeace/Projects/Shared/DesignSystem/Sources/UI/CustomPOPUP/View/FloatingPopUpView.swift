//
//  FloatingPopUpView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/4/24.
//

import SwiftUI
import ComposableArchitecture

public struct FloatingPopUpView: View {
    @Bindable var store: StoreOf<FloatingPopUp>
    var title: String
    var image: ImageAsset
    
    
    public init
    (store: StoreOf<FloatingPopUp>,
     title: String,
     image: ImageAsset
    ) {
        self.store = store
        self.title = title
        self.image = image
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.basicBlack.opacity(0.9))
            .frame(height: 56)
            .padding(.horizontal, 20)
            .overlay(alignment: .center) {
                HStack {
                    Spacer()
                    
                    Image(asset: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        
                    Spacer()
                        .frame(width: 8)
                    
                    Text(title)
                        .pretendardFont(family: .Regular, size: 16)
                        .foregroundStyle(Color.basicWhite)
                    
                    Spacer()
                }
            }
    }
}
