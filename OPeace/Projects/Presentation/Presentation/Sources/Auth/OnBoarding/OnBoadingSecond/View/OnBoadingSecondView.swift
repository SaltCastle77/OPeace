//
//  OnBoadingSecondView.swift
//  Presentation
//
//  Created by 서원지 on 7/30/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct  OnBoadingSecondView: View {
    @Bindable var store: StoreOf<OnBoadingSecond>
    
    public init(
        store: StoreOf<OnBoadingSecond>
    ) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: UIScreen.screenHeight * 0.1)
                
                onBoardingImageView()
                
                onBoarindSecondViewTitle()
                
                Spacer()
                    .frame(height: UIScreen.screenHeight * 0.2)
                
                
                CustomButton(
                    action: {
                        store.send(.switchTab)
                    }, title: store.presntNextViewButtonTitle,
                    config: CustomButtonConfig.create()
                    ,isEnable: true
                )
                .padding(.horizontal, 20)
                
                
                Spacer()
                    .frame(height: 16)
            }
        }
    }
    
}


extension OnBoadingSecondView {
    
    @ViewBuilder
    private func onBoardingImageView() -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray500)
                .frame(width: 240, height: 210)
                .overlay {
                    Image(asset: .onBoardingSecond)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 210)
                }
            
        }
    }
    
    
    @ViewBuilder
    private func onBoarindSecondViewTitle() -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 40)
            
            Text(store.onBoardingSecondTilte)
                .pretendardFont(family:.SemiBold, size: 28)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 3)
            
            Text(store.onBoardingSecondSubTilte)
                .pretendardFont(family:.SemiBold, size: 28)
                .foregroundStyle(Color.basicWhite)
            
        }
    }
    
    
}
