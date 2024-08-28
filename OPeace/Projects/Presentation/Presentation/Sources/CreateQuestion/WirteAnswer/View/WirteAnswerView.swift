//
//  WriteAnswerView.swift
//  Presentation
//
//  Created by 서원지 on 8/15/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

import Utill

public struct WriteAnswerView: View {
    @Bindable var store: StoreOf<WriteAnswer>
    @FocusState var choiceBFocus: Bool
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
                
                ScrollView {
                    writeAnswerChoice()
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.45)
                    
                    CustomButton(
                        action: {
                            store.send(.async(.createQuestion(
                                emoji: store.createQuestionEmoji.convertEmojiToUnicode(store.createQuestionEmoji),
                                title: store.createQuestionTitle,
                                choiceA: store.choiceAtext,
                                choiceB: store.choiceBtext)))
                            store.isCreateQuestion = true
                            
                            
                        }, title: store.presntWriteUploadViewButtonTitle,
                        config: CustomButtonConfig.create()
                        ,isEnable: !store.choiceAtext.isEmpty &&  !store.choiceBtext.isEmpty &&  store.enableButton)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 16)
                    
                }
                .bounce(false)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .popup(item: $store.scope(state: \.destination?.floatingPopUP, action: \.destination.floatingPopUP)) { floatingPopUpStore in
                FloatingPopUpView(store: floatingPopUpStore, title:  store.floatinPopUpText.isEmpty ? "14자까지 작성할 수 있어요": store.floatinPopUpText , image: .warning)
                
            }  customize: { popup in
                popup
                    .type(.floater(verticalPadding: UIScreen.screenHeight * 0.02))
                    .position(.bottom)
                    .animation(.spring)
                    .closeOnTap(true)
                    .closeOnTapOutside(true)
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
    
    @ViewBuilder
    private func writeAnswerChoice() -> some View {
        VStack {
            Spacer()
                .frame(height: 44)
            
            RoundTextField(
                choiceTitle: "A",
                placeholder: "내용을 입려해 주세요",
                choiceAnswerText: $store.choiceAtext,
                isErrorStoke: $store.isErrorEnableAnswerAStroke)  { newAnswer in
                    if newAnswer.count >= 14 {
                        store.enableButton = false
                        store.isErrorEnableAnswerAStroke = true
                        store.choiceAtext = String(newAnswer.prefix(14))
                        store.send(.view(.presntFloatintPopUp))
                        store.send(.view(.timeToCloseFloatingPopUp))
                    } else if newAnswer.count >= 1 {
                        if !newAnswer.isEmpty {
                            store.isErrorEnableAnswerAStroke = false
                            store.enableButton = true
                        }
                    } 
                } subitAction: {
                    choiceBFocus = true
                }
                
            
            Spacer()
                .frame(height: 8)
            
            RoundTextField(
                choiceTitle: "B",
                placeholder:  "내용을 입려해 주세요",
                choiceAnswerText: $store.choiceBtext,
                isErrorStoke: $store.isErrorEnableAnswerBStroke) { newAnswer in
                    if newAnswer.count >= 14 {
                        store.enableButton = false
                        store.isErrorEnableAnswerBStroke = true
                        store.choiceBtext = String(newAnswer.prefix(14))
                        store.send(.view(.presntFloatintPopUp))
                        store.send(.view(.timeToCloseFloatingPopUp))
                    } else if newAnswer.count >= 1 {
                        if !newAnswer.isEmpty {
                            store.enableButton = true
                            store.isErrorEnableAnswerBStroke = false
                        }
                    }
                } subitAction: {}
                .focused($choiceBFocus)
        }
    }
}
