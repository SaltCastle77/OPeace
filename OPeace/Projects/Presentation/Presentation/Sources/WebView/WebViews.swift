//
//  WebViews.swift
//  DesignSystem
//
//  Created by 서원지 on 7/25/24.
//

import SwiftUI
import DesignSystem

import ComposableArchitecture

public struct WebViews: View {
    @Bindable var store: StoreOf<Web>
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var backAction: () -> Void
    
    public init(
        store: StoreOf<Web>,
        backAction: @escaping() -> Void
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
                
                NavigationBackButton(buttonAction:  {
                    backAction()
                })
                
                Spacer()
                    .frame(height: 16)
                
                if store.loading {
                    
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .frame(width: 100, height: 100)
                    
                    Spacer()
                    
                } else {
                    WebView(urlToLoad: store.url)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                store.send(.startLoading)
            }
        }
    }
}

