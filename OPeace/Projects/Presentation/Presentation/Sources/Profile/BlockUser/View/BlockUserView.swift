//
//  BlockUserView.swift
//  Presentation
//
//  Created by 서원지 on 8/27/24.
//

import SwiftUI

import ComposableArchitecture
import PopupView

import DesignSystem

public struct BlockUserView: View {
    @Bindable var store: StoreOf<BlockUser>
    var backAction: () -> Void = { }
    
    public init(
        store: StoreOf<BlockUser>,
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
                
                CustomTitleNaviagionBackButton(buttonAction: backAction, title: "차단 관리")
                
                blockUserHeader()
                
                ScrollView(showsIndicators: false) {
                    userBlockListView()
                   
                }
                
                Spacer()
            }
            .onAppear {
                store.send(.async(.fetchUserBlockList))
            }
            .popup(item: $store.scope(state: \.destination?.floatingPopUP, action: \.destination.floatingPopUP)) { floatingPopUpStore in
                FloatingPopUpView(store: floatingPopUpStore, title: "차단이 해제되었어요", image: .succesLogout)
                    .onAppear{
                        store.send(.view(.timeToCloseFloatingPopUp))
                    }
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


extension BlockUserView {
    
    @ViewBuilder
    private func blockUserHeader() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            HStack {
                Text("차단 목록")
                    .pretendardFont(family: .Medium, size: 16)
                    .foregroundStyle(Color.gray200)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func userBlockListView() -> some View {
        if store.userBlockListModel?.data == [] {
            noBlockUserView()
        } else {
            blockUserListView()
        }
    }
    
    @ViewBuilder
    private func blockUserListView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            if let userBlockData = store.userBlockListModel?.data {
                ForEach(userBlockData, id: \.id) { item in
                    blockUserListItem(
                        nickName: "엠제이엠제이",
                        job: "개발",
                        generation: "Z 세대",
                        completion: {
                            store.send(.async(.realseUserBlock(blockUserID: item.blockedUserID ?? "")))
                        })
                }
            }
        }
    }
    
    @ViewBuilder
    private func noBlockUserView() -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.3)
            
            Text("차단 목록이 비어있어요")
                .pretendardFont(family: .SemiBold, size: 24)
                .foregroundStyle(Color.gray200)
            
            Spacer()
                .frame(height: 16)
            
            HStack {
                Text("고민 카드 우측 상단에")
                    .pretendardFont(family: .Medium, size: 16)
                    .foregroundStyle(Color.gray200)
                
                Spacer()
                    .frame(width: 2)
                
                Image(asset: .questionEdit)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                
                Spacer()
                    .frame(width: 2)
                
                Text("를 누르면")
                    .pretendardFont(family: .Medium, size: 16)
                    .foregroundStyle(Color.gray200)
            }
            
            Text("차단할 수 있어요")
                .pretendardFont(family: .Medium, size: 16)
                .foregroundStyle(Color.gray200)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func blockUserListItem(
        nickName: String,
        job: String,
        generation: String,
        completion: @escaping () -> Void
    ) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray500)
            .padding(.horizontal, 20)
            .frame(height: 72)
            .overlay {
                VStack {
                    Spacer()
                        .frame(height: 28)
                    
                    HStack(spacing: .zero) {
                        Spacer()
                            .frame(width: 16)
                        
                        Text(nickName)
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(Color.basicWhite)
                        
                        Spacer()
                            .frame(width: 8)
                        
                        Text(job)
                            .pretendardFont(family: .Medium, size: 14)
                            .foregroundStyle(Color.gray200)
                        
                        Spacer()
                            .frame(width: 8)
                        
                        Rectangle()
                            .fill(Color.gray400)
                            .frame(width: 1, height: 10)
                        
                        Spacer()
                            .frame(width: 8)
                        
                        Text(generation)
                            .pretendardFont(family: .Medium, size: 14)
                            .foregroundStyle(Color.gray200)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.gray400, style: .init(lineWidth: 1))
                            .frame(width: 72, height: 32)
                            .background(Color.gray500)
                            .clipShape(Capsule())
                            .overlay {
                                Text("차단 해제")
                                    .pretendardFont(family: .Medium, size: 14)
                                    .foregroundStyle(Color.gray200)
                            }
                            .onTapGesture {
                                completion()
                            }
                        
                        Spacer()
                            .frame(width: 16)
                        
                    }
                    .padding(.horizontal, 16)
                    
                    
                    Spacer()
                        .frame(height: 28)
                }
            }
    }
}
