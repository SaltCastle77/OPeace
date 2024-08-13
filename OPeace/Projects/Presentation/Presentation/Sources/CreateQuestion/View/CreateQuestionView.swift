//
//  CreateQuestionView.swift
//  Presentation
//
//  Created by 서원지 on 8/14/24.
//

import SwiftUI

import DesignSystem

import ComposableArchitecture
import PopupView

public struct CreateQuestionView: View {
    @Bindable var store: StoreOf<CreateQuestion>
    var backAction: () -> Void = { }
    
    public init(
        store: StoreOf<CreateQuestion>,
        backAction: @escaping () -> Void
    ) {
        self.store = store
        self.backAction = backAction
    }
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                    .frame(height: 14)
                
                CustomTitleNaviagionBackButton(buttonAction: backAction, title: "고민 작성하기")
                
                Spacer()
                
                
            }
        }
    }
}
