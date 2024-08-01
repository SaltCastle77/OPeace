//
//  HomeView.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI
import DesignSystem

import ComposableArchitecture

public struct HomeView: View {
    @Bindable var store: StoreOf<Home>
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                navigationBaritem()
                
                Spacer()
            }
        }
    }
}

extension HomeView {
    
    @ViewBuilder
    private func navigationBaritem() -> some View {
        LazyVStack {
            Spacer()
                .frame(height: 22)
            
            
            HStack {
                Spacer()
                
                Circle()
                    .fill(Color.gray500)
                    .frame(width: 40, height: 40)
                    .overlay {
                        VStack{
                            Image(systemName: store.profileImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 16)
                                .foregroundStyle(Color.gray200)
                                
                        }
                    }
            }
            .padding(.horizontal, 16)
        }
    }
}
