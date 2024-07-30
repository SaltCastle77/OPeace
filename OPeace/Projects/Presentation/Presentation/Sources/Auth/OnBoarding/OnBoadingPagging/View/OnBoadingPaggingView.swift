//
//  OnBoadingPaggingView.swift
//  Presentation
//
//  Created by 서원지 on 7/30/24.
//

import SwiftUI
import DesignSystem
import Model
import ComposableArchitecture

public struct OnBoadingPaggingView: View {
    
    @Bindable var store: StoreOf<OnBoadingPagging>
    private var backAction: () -> Void =  {}
    
    public init(
        store: StoreOf<OnBoadingPagging>,
        backAction: @escaping () -> Void
    ) {
        self.store = store
        self.backAction = backAction
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 14)
                
                NavigationBackButton(buttonAction: backAction)
                
                Spacer()
                    .frame(height: 20)
                
                DotBarView(activeIndex: $store.activeMenu)
                
                
                TabView(selection: $store.activeMenu) {
                    OnBoardingFirstView(store: self.store.scope(state: \.onBoardingFirst, action: \.onBoardingFirst))
                        .tag(OnBoardingTab.onBoardingFirst)
                    
                    OnBoardingFirstView(store: self.store.scope(state: \.onBoardingFirst, action: \.onBoardingFirst))
                        .tag(OnBoardingTab.onBoardingSecond)
                    
                    OnBoardingFirstView(store: self.store.scope(state: \.onBoardingFirst, action: \.onBoardingFirst))
                        .tag(OnBoardingTab.onBoardingLast)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.none, value: store.activeMenu)
                
                Spacer()
            }
        }
         
    }
}
