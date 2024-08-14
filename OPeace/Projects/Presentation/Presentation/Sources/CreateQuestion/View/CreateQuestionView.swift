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
import ISEmojiView

import Utill

public struct CreateQuestionView: View {
    @Bindable var store: StoreOf<CreateQuestion>
    var backAction: () -> Void = { }
    @State private var isFocused: Bool = false
    
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
                
                ScrollView(showsIndicators: false) {
                    selectQuestionEmojeView()
                    
                    wittingQustionView()
                    
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.35)
                    
                    CustomButton(
                        action: {
                          
                            
                            
                        }, title: store.presntNextViewButtonTitle,
                        config: CustomButtonConfig.create()
                        ,isEnable: !store.isWriteTextEditor.isEmpty)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 16)
                }
                .bounce(false)
                
               
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            
        }
    }
}

extension CreateQuestionView {
    
    @ViewBuilder
    private func selectQuestionEmojeView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            if store.isInupustEmoji {
                HStack {
                    Spacer()
                        .frame(width: UIScreen.screenWidth * 0.4)
                        
                    EmojiTextField(text: $store.selectEmojiText, emojiImage: $store.emojiImage, isInputEmoji: $store.isInupustEmoji, placeholder: "")
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            UIApplication.shared.hideKeyboard()
                        }
                    
                    Spacer()
                }
                
                UnderlineView(text: store.selectEmojiText.isEmpty ? "😀" : store.selectEmojiText)
                
            } else if let emojiImage = store.emojiImage {
                emojiImage
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .onTapGesture {
                        store.isInupustEmoji.toggle()
                        store.selectEmojiText = ""
                    }
                    .offset(x: 10)
            } else {
                Circle()
                    .fill(Color.gray500)
                    .frame(width: 80, height: 80)
                    .overlay(alignment: .center) {
                        Image(asset: .plus)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                store.isInupustEmoji.toggle()
                            }
                    }
            }
            
            
            
            
        }
        .padding()
    }
    
    @ViewBuilder
    private func wittingQustionView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            TextEditor(text: $store.isWriteTextEditor)
                .modifier(TextEditorModifier(placeholder: "여기를 눌러서 작성해주세요.", text: $store.isWriteTextEditor))
                .frame(height: 160)
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
            
            Spacer()
                .frame(height: 12)
            
            Text("\(store.isWriteTextEditor.count) / 60")
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray300)
                .onChange(of: store.isWriteTextEditor) { newValue, oldValue in
                    if newValue.count > 60 {
                        store.isWriteTextEditor = String(newValue.prefix(60))
                    }
                }
               
        }
        .padding(.horizontal ,20)
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
    }
}





