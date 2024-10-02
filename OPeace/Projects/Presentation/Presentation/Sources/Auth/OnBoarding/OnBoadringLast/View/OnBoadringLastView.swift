//
//  OnBoadringLastView.swift
//  Presentation
//
//  Created by 서원지 on 7/30/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct  OnBoadringLastView: View {
    @Bindable var store: StoreOf<OnBoadringLast>
    var compltion: () -> Void = { }
    
    public init(
        store: StoreOf<OnBoadringLast>,
        compltion: @escaping () -> Void
    ) {
        self.store = store
        self.compltion = compltion
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: UIScreen.screenHeight * 0.1)
                
                onBoardingImageView()
                
                onBoarindLastViewTitle()
                
                Spacer()
                    .frame(height: UIScreen.screenHeight * 0.2)
                
                
                CustomButton(
                    action: {
                        compltion()
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


extension OnBoadringLastView {
    
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
    private func onBoarindLastViewTitle() -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 40)
            
            Text(store.onBoardingLastTilte)
                .pretendardFont(family:.SemiBold, size: 28)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 3)
            
            Text(store.onBoardingLastSubTilte)
                .pretendardFont(family:.SemiBold, size: 28)
                .foregroundStyle(Color.basicWhite)
            
        }
    }
    
    
}
