//
//  ProfileView.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI
import DesignSystem

import ComposableArchitecture
import PopupView
import SwiftUIIntrospect

import Utill

public struct ProfileView: View {
    @Bindable var store: StoreOf<Profile>

    var backAction: () -> Void = {}
    
    
    public init(
        store: StoreOf<Profile>,
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
                
                CustomTitleNaviagionBackButton(buttonAction: backAction, title: "마이페이지")
                
                userInfoTitle(
                    nickName: store.profileUserModel?.data?.nickname ?? "",
                    job: store.profileUserModel?.data?.job ?? "",
                    generation: store.profileUserModel?.data?.generation ?? "")
                
                myPostWritingTitle()
                
                Spacer()
            }
            .onAppear {
                store.send(.async(.fetchUser))
            }
            .introspect(.navigationStack, on: .iOS(.v17, .v18)) { navigationController in
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
            }
            .sheet(item: $store.scope(state: \.destination?.setting, action: \.destination.setting)) { settingStore in
                SettingView(store: settingStore) {
                    guard let settingtitem =  settingStore.settingtitem else {return}
                    store.send(.view(.switchModalAction(settingtitem )))
                } closeModalAction: {
                    store.send(.view(.closeModal))
                }
                .presentationDetents([.height(UIScreen.screenHeight * 0.3)])
                .presentationCornerRadius(20)
                .presentationDragIndicator(.hidden)
            }
            
            .popup(item: $store.scope(state: \.destination?.popup, action: \.destination.popup)) { customPopUp in
                CustomBasicPopUpView(store: customPopUp, title: store.logoutPopUpTitle) {
                    store.send(.async(.logoutUser))
                } cancelAction: {
                    store.send(.view(.closeModal))
                }
                
            }  customize: { popup in
                popup
                    .type(.floater(verticalPadding: UIScreen.screenHeight * 0.35))
                    .position(.bottom)
                    .animation(.spring)
                    .closeOnTap(true)
                    .closeOnTapOutside(true)
                    .backgroundColor(Color.basicBlack.opacity(0.8))
            }
            
            .popup(item: $store.scope(state: \.destination?.deletePopUp, action: \.destination.deletePopUp)) { customPopUp in
                CustomBasicPopUpView(store: customPopUp, title: store.deletePopUpTitle) {
                    store.send(.view(.closeModal))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        store.send(.navigation(.presntWithDraw))
                    }
                } cancelAction: {
                    store.send(.view(.closeModal))
                }
                
            }  customize: { popup in
                popup
                    .type(.floater(verticalPadding: UIScreen.screenHeight * 0.35))
                    .position(.bottom)
                    .animation(.spring)
                    .closeOnTap(true)
                    .closeOnTapOutside(true)
                    .backgroundColor(Color.basicBlack.opacity(0.8))
            }
        }
    }
}


extension ProfileView {
    
    @ViewBuilder
    private func userInfoTitle(
        nickName: String,
        job: String,
        generation: String
    ) -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            HStack {
                Text(nickName)
                    .pretendardFont(family: .SemiBold, size: 24)
                    .foregroundStyle(Color.basicWhite)
                
                Spacer()
                    .frame(width: 4)
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray400, style: .init(lineWidth: 1.13))
                    .frame(width:  job.calculateWidthProfile(for: job), height: 24)
                    .background(Color.gray600)
                    .overlay(alignment: .center) {
                        Text(job)
                            .pretendardFont(family: .Regular, size: 12)
                            .foregroundStyle(Color.basicWhite)
                    }
                
                Spacer()
                    .frame(width: 4)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(store.profileGenerationColor)
                    .frame(width: generation.calculateWidthProfileGeneration(for: generation), height: 24)
                    .overlay(alignment: .center) {
                        Text(generation)
                            .pretendardFont(family: .Regular, size: 12)
                            .foregroundStyle(store.profileGenerationTextColor)
                    }
                
                
                Spacer()
                    .frame(width: 4)
                
                Image(asset: .setting)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        store.send(.view(.tapPresntSettingModal))
                    }
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    private func myPostWritingTitle() -> some View {
        VStack {
            Spacer()
                .frame(height: 32)
            
            HStack {
                Text("내가 올린 글")
                    .pretendardFont(family: .Regular, size: 16)
                    .foregroundStyle(Color.gray200)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    private func myPostitngList() -> some View {
        
    }
}
