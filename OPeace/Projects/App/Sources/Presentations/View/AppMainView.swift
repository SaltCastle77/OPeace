//
//  ContentView.swift
//  OPeace
//
//  Created by 염성훈 on 1/17/24.
//  Copyright © 2024 Yeom. All rights reserved.
//

import Foundation
import SwiftUI
import Moya
import Feature
import ComposableArchitecture
import DesignSystemKit

struct AppMainView: View {
    
    @State var path: [ViewContent] = []
    @State private var isActiveSplashView = true
    
    var body: some View {
        
        if isActiveSplashView {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.isActiveSplashView = false
                    })
                }
        } else {
            NavigationStack(path: $path) {
                Text("Hello, World!")
                Button(action: {
                    path.append(ViewContent(number: 0, content: "onboardingContent"))
                }, label: {
                    Text("다음화면으로 이동")
                        .foregroundStyle(DesignSystemKitAsset.ColorAsset.grayScale100.swiftUIColor)
                })
                .navigationDestination(for: ViewContent.self) { next in
                    OnBoardingView(number: next.number, content: next.content, path: $path)
                }
            }
        }
    }
}


#Preview {
    AppMainView()
}
