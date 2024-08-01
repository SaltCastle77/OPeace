//
//  ProfileView.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI
import DesignSystem

import ComposableArchitecture
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
                
                userInfoTitle(nickName: "엠제이엠제이", job: "개발", generation: "Z세대")
                
                Spacer()
            }
        }
    }
}


extension ProfileView {

    @ViewBuilder
    private func userInfoTitle(nickName: String, job: String, generation: String) -> some View {
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
                    .frame(width: generation.calculateWidth(for: generation), height: 24)
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
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            let (generation, color, textColor) = CheckRegister.getGeneration(year: 1998, color: store.profileGenerationColor, textColor: store.profileGenerationTextColor)
            store.profileGenerationText = generation
            store.profileGenerationColor = color
            store.profileGenerationTextColor = textColor
        }
    }
}
