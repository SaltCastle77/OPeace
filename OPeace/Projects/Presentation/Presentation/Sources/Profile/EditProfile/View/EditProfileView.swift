//
//  EditProfileView.swift
//  Presentation
//
//  Created by 서원지 on 8/4/24.
//

import SwiftUI

import ComposableArchitecture

import Utill
import DesignSystem
import PopupView

public struct EditProfileView: View {
    @Bindable var store: StoreOf<EditProfile>
    var backAction: () -> Void = { }
    var backToHomeAction: () -> Void = { }
    
    public init(
        store: StoreOf<EditProfile>,
        backAction: @escaping () -> Void,
        backToHomeAction: @escaping () -> Void
    ) {
        self.store = store
        self.backAction = backAction
        self.backToHomeAction = backToHomeAction
    }
    
    
    public var body: some View {
        ZStack {
            Color.gray600
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 14)
                
                CustomTitleNaviagionBackButton(buttonAction: backAction, title: "내 정보 수정")
                
                ScrollView(.vertical, showsIndicators: false) {
                    editNameTextField()
                    
                    erorNIckCheckText()
                    
                    signUpJobSelect()
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.1)
                    
                    CustomButton(
                        action: {
                            store.send(.async(.updateUserInfo(
                                nickName: store.editProfileName,
                                year: store.profileYear ,
                                job:  store.profileSelectedJob ?? "",
                                generation: store.editProfileGenerationText)))
                            store.isChangeProfile = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                backToHomeAction()
                            }
                        }, title: store.editProfileComplete,
                        config: CustomButtonConfig.create()
                        ,isEnable: !store.editProfileName.isEmpty  && store.enableButton
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 16)
                }
                .bounce(false)
            }
            .task {
                store.send(.async(.fetchUser))
                store.send(.async(.fetchEditProfileJobList))
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                checkChangeProfileName()
            }
        }
    }
}

extension EditProfileView {
    @ViewBuilder
    private func editNameTextField() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.08)
            
            TextField(store.profileName, text: $store.editProfileName)
                .pretendardFont(family: .SemiBold, size: store.editProfileName.isEmpty ? 48 : 48)
                .foregroundStyle(store.editProfileName.isEmpty ? Color.gray300 : Color.basicWhite)
                .multilineTextAlignment(.center)
                .submitLabel(.done)
                .onSubmit {
                    checkChangeProfileName()
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            Spacer()
                .frame(height: 12)
            
            UnderlineView(text: store.editProfileName.isEmpty ? store.profileName : store.editProfileName)

        }
    }
    
    
    @ViewBuilder
    private func erorNIckCheckText() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            if store.editProfileName.isEmpty {
                Text(store.checkNickNameMessage)
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(store.enableButton ? Color.basicPrimary : Color.alertError)
            } else {
                Text(store.checkNickNameMessage)
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(store.enableButton ? Color.basicPrimary : Color.alertError)
            }
        }
    }
    
    @ViewBuilder
    private func signUpJobSelect() -> some View {
        VStack {
            Spacer()
                .frame(height: 20)
            
            ScrollView {
                VStack(spacing: 12) {
                    if let categories = store.editProfileJobModel?.data?.data {
                        ForEach(0..<(categories.count / 4 + (categories.count % 4 > 0 ? 1 : 0)), id: \.self) { rowIndex in
                            let startIndex = rowIndex * 4
                            let endIndex = min(startIndex + 4, categories.count)
                            let padding = rowIndex < store.paddings.count ? store.paddings[rowIndex] : store.paddings.last ?? 0
                            createRow(startIndex: startIndex, endIndex: endIndex, padding: padding, categories: categories)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    func createRow(
        startIndex: Int,
        endIndex: Int,
        padding: CGFloat,
        categories: [String]
    ) -> some View {
        HStack {
            Spacer(minLength:  padding)
            ForEach(startIndex..<endIndex, id: \.self) { index in
                signUpSelectButton(jobTitle: categories[index], width: categories[index].calculateWidth(for: categories[index]))
            }
            Spacer(minLength:  padding)
                
        }
    }
    
    @ViewBuilder
    private func signUpSelectButton(
        jobTitle: String,
        width: CGFloat
    ) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(store.profileSelectedJob == jobTitle ? Color.basicPrimary : Color.gray500)
            .frame(width: width, height: 38)
            .overlay {
                Text(jobTitle)
                    .pretendardFont(family: .Regular, size: 18)
                    .foregroundStyle(store.profileSelectedJob == jobTitle ? Color.gray600 : Color.gray100)
                    .foregroundStyle(Color.gray100)
            }
            .onTapGesture {
                store.send(.view(.selectJob(jobTitle)))
            }
    }
    
    private func checkChangeProfileName() {
        if CheckRegister.isValidNickName(store.editProfileName) {
            store.checkNickNameMessage = "사용 가능한 닉네임이에요"
            store.enableButton = true
            store.send(.async(.checkNickName(nickName: store.editProfileName)))
        } else if CheckRegister.containsInvalidCharacters(store.editProfileName) {
            store.checkNickNameMessage = "띄어쓰기와 특수문자는 사용할 수 없어요"
            store.enableButton = false
        } else if store.editProfileName.isEmpty {
            store.checkNickNameMessage = "닉네임은 5글자 이하까지 입력 가능해요"
            store.enableButton = false
        }  else if CheckRegister.containsInvalidCharacters(store.editProfileName) {
            store.enableButton = false
        } else {
            store.checkNickNameMessage = "닉네임은 5글자 이하까지 입력 가능해요"
            store.enableButton = false
        }
    }
}
