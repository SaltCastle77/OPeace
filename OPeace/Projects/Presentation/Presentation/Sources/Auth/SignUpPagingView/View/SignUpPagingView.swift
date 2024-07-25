//
//  SignUpPagingView.swift
//  Presentation
//
//  Created by 서원지 on 7/24/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct SignUpPagingView: View {
    @Bindable var store: StoreOf<SignUpPaging>
    var backAction: () -> Void = { }
    
    public init(
        store: StoreOf<SignUpPaging>,
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
                
                NavigationBackButton {
                    if store.selectedTab == 0 {
                       backAction()
                    } else {
                        store.send(.view(.backSelectTab))
                    }
                    
                    
                }
                
                Spacer()
                    .frame(height: 27)
                
                DotBarView(activeIndex: $store.selectedTab, totalDots: store.totalTabs)
                 
                TabView(selection: $store.selectedTab) {
                    SignUpNameView(store: Store(initialState: SignUpName.State(), reducer: {
                        SignUpName()
                    }) )
                    .tag(0)
                    
                    Text("나이입력")
                        .tag(1)
                    
                    Text("직무선택")
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if store.selectedTab == 0  {
                                if value.translation.width > 100 {
                                    backAction()
                            }
                        }
                    }
                )
                
                
            }
            
        }
        
    }
}

