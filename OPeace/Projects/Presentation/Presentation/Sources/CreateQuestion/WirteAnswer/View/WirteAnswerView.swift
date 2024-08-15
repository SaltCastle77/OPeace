//
//  WriteAnswerView.swift
//  Presentation
//
//  Created by 서원지 on 8/15/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct WriteAnswerView: View {
    @Bindable var store: StoreOf<WriteAnswer>
    var backAction: () -> Void
    
    public init(
        store: StoreOf<WriteAnswer>,
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
                
                CustomTitleNaviagionBackButton(buttonAction: backAction, title: "답변 작성하기")
                
                writeAnswerEmoji()
                
                Spacer()
            }
        }
    }
}

extension WriteAnswerView {
    
    @ViewBuilder
    private func writeAnswerEmoji() -> some View {
        VStack {
            Spacer()
                .frame(height: 32)
            
            if let wirteAnswerEmoji = Image.emojiToImage(emoji: store.createQuestionEmoji) {
                wirteAnswerEmoji
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .offset(x: 10)
            }
            
            
        }
    }
}
