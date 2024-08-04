//
//  CustomBasicPopUpView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/3/24.
//

import SwiftUI
import ComposableArchitecture


public struct CustomBasicPopUpView: View {
    @Bindable var store: StoreOf<CustomPopUp>
    
    private var title: String
    private var confirmAction: () -> Void = { }
    private var cancelAction: () -> Void = { }
    
    public init(
        store: StoreOf<CustomPopUp>,
        title: String,
        confirmAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) {
        self.store = store
        self.title = title
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray500)
            .frame(height: 240)
            .padding(.horizontal, 31)
            .overlay(alignment: .center) {
                VStack {
                    popupTitleContent()
                    
                    popupConfirmButton()
                    
                    Spacer()
                }
            }
            
        
    }
}


extension CustomBasicPopUpView {
    
    @ViewBuilder
    private func popupTitleContent() -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 80)
            
            Text(title)
                .pretendardFont(family: .Regular, size: 20)
                .foregroundStyle(Color.basicWhite)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
    
    
    @ViewBuilder
    private func popupConfirmButton() -> some View {
        VStack {
            Spacer()
                .frame(height: 56)
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray400)
                    .frame(width: 135, height: 56)
                    .clipShape(Capsule())
                    .overlay(alignment: .center) {
                        Text("아니오")
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
                        Text("네")
                            .pretendardFont(family: .Medium, size: 16)
                            .foregroundStyle(Color.textColor100)
                    }
                    .onTapGesture {
                        confirmAction()
                    }
                
            }
            .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: 20)
        }
    }
}
