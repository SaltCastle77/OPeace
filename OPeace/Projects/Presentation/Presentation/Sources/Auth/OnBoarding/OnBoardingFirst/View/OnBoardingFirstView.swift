//
//  OnBoardingFirstView.swift
//  Presentation
//
//  Created by 서원지 on 7/30/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct  OnBoardingFirstView: View {
    @Bindable var store: StoreOf<OnBoardingFirst>
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: UIScreen.screenHeight * 0.02)
                
                onBoardingImageView()
                
                onBoarindFirstViewTitle()
                
                Spacer()
                    .frame(height: UIScreen.screenHeight * 0.3)
                
                
                CustomButton(
                    action: {
                       
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


extension OnBoardingFirstView {
    
    @ViewBuilder
    private func onBoardingImageView() -> some View {
        VStack {
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray500)
                        .frame(width: 240, height: 210)
                        .overlay {
                            Image(asset: .onBoardingFirst)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 240, height: 210)
                        }
                    
                }
                Image(asset: .onBoardingFirstTap)
                    .resizable()
                    .scaledToFit()
                  .frame(width: 30, height: 43)
                  .offset(x: 40, y: 130)
                  .rotationEffect(.degrees(60))
                  .scaleEffect(x: -1, y: 1)
            }
        }
    }
    
    
    @ViewBuilder
    private func onBoarindFirstViewTitle() -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 40)
            
            Text(store.onBoardingFirstTilte)
                .pretendardFont(family:.SemiBold, size: 28)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 3)
            
            Text(store.onBoardingFirstSubTilte)
                .pretendardFont(family:.SemiBold, size: 28)
                .foregroundStyle(Color.basicWhite)
            
        }
    }
    
    
}
