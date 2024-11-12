//
//  SplashView.swift
//  Presentation
//
//  Created by 서원지 on 7/21/24.
//


import Foundation
import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct SplashView: View {
  @Bindable var store: StoreOf<Splash>
  
  public init(
    store: StoreOf<Splash>
  ) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      Image(asset: store.backgroundmage)
        .resizable()
        .scaledToFill()
        .ignoresSafeArea(.all)
      
      Image(asset: store.applogoImage)
        .resizable() 
        .scaledToFit()
        .frame(height: 48)
      
    }
    .onAppear {
      store.send(.async(.checkUserVerfiy))
      store.checkVersionShowPopUp = false
    }
  }
}


