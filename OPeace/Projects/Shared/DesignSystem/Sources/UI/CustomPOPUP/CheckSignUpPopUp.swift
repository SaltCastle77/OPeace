//
//  CheckSignUpPopUp.swift
//  DesignSystem
//
//  Created by 서원지 on 7/28/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture

public struct CheckSignUpPopUp: View {
    
    @Bindable var store: StoreOf<CustomPopUp>
    
    var nickName: String
    var yearOfBirth: String
    var job: String
    var cancelAction: () -> Void = { }
    
    public init(
        store: StoreOf<CustomPopUp>,
        nickName: String,
        yearOfBirth: String,
        job: String,
        cancelAction: @escaping () -> Void
    ) {
        self.store = store
        self.nickName = nickName
        self.yearOfBirth = yearOfBirth
        self.job = job
        self.cancelAction = cancelAction
    }
    
    public var body: some View{
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray500)
            .frame(height: UIScreen.screenHeight * 0.58)
            .padding(.horizontal, 31)
            .overlay(alignment: .center) {
                VStack {
                    checkPopUpTitle()
                    
                    checkPopUpSignUpInfo()
                    
                    checkSignUpButton()
                    
                    Spacer()
                        .frame(height: 20)
                }
            }
    }
    
}

extension CheckSignUpPopUp {
    
    @ViewBuilder
    private func checkPopUpTitle() -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 40)
            
            Text("다시 한번 확인해 주세요")
                .pretendardFont(family: .Medium, size: 20)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 8)
            
            
            Text("정보가 일치하면 가입하기를 눌러주세요.")
                .pretendardFont(family: .Regular, size: 15)
                .foregroundStyle(Color.gray200)
            
        }
    }
    
    @ViewBuilder
    private func checkPopUpSignUpInfo() -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 32)
            
            Text("닉네임")
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray200)
            
            Spacer()
                .frame(height: 12)
            
            Text(nickName)
                .pretendardFont(family: .SemiBold, size: 24)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 16)
            
            Text("츌생년도")
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray200)
            
            Spacer()
                .frame(height: 12)
            
            Text(yearOfBirth)
                .pretendardFont(family: .SemiBold, size: 24)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 16)
            
            Text("직무")
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray200)
            
            Spacer()
                .frame(height: 12)
            
            Text(job)
                .pretendardFont(family: .SemiBold, size: 24)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 32)
            
            Text("출생 연도는 추후 변경할 수 없어요!")
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.alertError)
            
        }
    }
    
    @ViewBuilder
    private func checkSignUpButton() -> some View {
        VStack {
            Spacer()
                .frame(height: 32)
            
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray400)
                    .frame(width: 135, height: 56)
                    .clipShape(Capsule())
                    .overlay(alignment: .center) {
                        Text("다시 입력")
                            .pretendardFont(family: .Medium, size: 16)
                            .foregroundStyle(Color.basicWhite)
                    }
                    .onTapGesture {
                        cancelAction()
                    }
                    
                
                Spacer()
                    .frame(width: 8)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.basicPrimary)
                    .frame(width: 135, height: 56)
                    .clipShape(Capsule())
                    .overlay(alignment: .center) {
                        Text("가입 하기")
                            .pretendardFont(family: .Medium, size: 16)
                            .foregroundStyle(Color.textColor100)
                    }
                
            }
            .padding(.horizontal, 20)
        }
    }
}


