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

import SwiftUIIntrospect

import Utill

public struct WriteQuestionView: View {
    @Bindable var store: StoreOf<WriteQuestion>
    var backAction: () -> Void = { }
    @FocusState var isFocused: Bool
    
    public init(
        store: StoreOf<WriteQuestion>,
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
                            store.send(.navigation(.presntWriteAnswer))
                        }, title: store.presntNextViewButtonTitle,
                        config: CustomButtonConfig.create()
                        ,isEnable: !store.createQuestionUserModel.createQuestionTitle.isEmpty &&
                        store.emojiImage != nil
                        && store.enableButton
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 16)
                }
                .bounce(false)
                
            }
            .popup(item: $store.scope(state: \.destination?.floatingPopUP, action: \.destination.floatingPopUP)) { floatingPopUpStore in
                FloatingPopUpView(store: floatingPopUpStore, title:  "60자까지 작성할 수 있어요" , image: .warning)
                
            }  customize: { popup in
                popup
                    .type(.floater(verticalPadding: UIScreen.screenHeight * 0.02))
                    .position(.bottom)
                    .animation(.spring)
                    .closeOnTap(true)
                    .closeOnTapOutside(true)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

extension WriteQuestionView {
    
    @ViewBuilder
    private func selectQuestionEmojeView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)

            if store.isInuputEmoji {
                HStack {
                    Spacer()
                        .frame(width: UIScreen.main.bounds.width * 0.4)
                    
                    EmojiTextField(
                        text: $store.createQuestionUserModel.createQuestionEmoji,
                        emojiImage: $store.emojiImage,
                        isInputEmoji: $store.isInuputEmoji,
                        isEmojiActive: $store.isActiveEmoji )
                        .pretendardFont(family: .SemiBold, size: 48)
                        .onChange(of: store.createQuestionUserModel.createQuestionEmoji) { oldValue, newValue in
                            if newValue.count == 1, newValue.unicodeScalars.allSatisfy({ $0.properties.isEmoji }) {
                                self.store.emojiImage = Image.emojiToImage(emoji: newValue)
                                store.isInuputEmoji = false
                                store.isActiveEmoji = false
                            } else {
                                store.createQuestionUserModel.createQuestionEmoji = ""
                            }
                        }
                        .focused($isFocused)
                        .opacity(store.isActiveEmoji ? 0.1 : 0)
                        .overlay {
                            if store.isActiveEmoji {
                                Image(asset: .activeEmojiI)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .onTapGesture {
                                        // Return to text field view
                                        store.isActiveEmoji = false
                                        store.isInuputEmoji = true
                                        isFocused = true
                                    }
                                    .offset(x: -75)
                            }
                        }
                        
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 15)
                
              HStack {
                    Spacer()
                  
                  Divider()
                      .frame(width: 80, height: 1)
                      .background(Color.gray200)
                  
                  Spacer()
                }

            } else if let emojiImage = store.emojiImage {
                emojiImage
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                        store.isInuputEmoji.toggle()
                        store.createQuestionUserModel.createQuestionEmoji = ""
                        store.isActiveEmoji.toggle()
                        isFocused.toggle()
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
                                store.isInuputEmoji.toggle()
                                isFocused.toggle()
                                store.isActiveEmoji.toggle()
                                UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
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
            
            TextEditor(text: $store.createQuestionUserModel.createQuestionTitle)
                .modifier(
                    TextEditorModifier(
                        placeholder: "여기를 눌러서 작성해주세요.",
                        text: $store.createQuestionUserModel.createQuestionTitle
                    )
                )
                .frame(height: 160)
            
            Spacer()
                .frame(height: 12)
            
            Text("\(store.createQuestionUserModel.createQuestionTitle.count) / 60")
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray300)
                .onChange(of: store.createQuestionUserModel.createQuestionTitle) { newValue, oldValue in
                    if newValue.count >= 60 {
                        store.enableButton = false
                        store.createQuestionUserModel.createQuestionTitle = String(newValue.prefix(60))
                        store.send(.view(.presntFloatintPopUp))
                        store.send(.view(.timeToCloseFloatingPopUp))
                    } else {
                        store.enableButton = true
                    }
                }
        }
        .padding(.horizontal ,20)
        
    }
}





