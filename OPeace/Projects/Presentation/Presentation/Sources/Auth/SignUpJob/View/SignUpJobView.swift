//
//  SignUpJobView.swift
//  Presentation
//
//  Created by 서원지 on 7/27/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem
import PopupView

public struct SignUpJobView: View {
    @Bindable var store: StoreOf<SignUpJob>
    private var confirmAction: () -> Void
    
    public init(
        store: StoreOf<SignUpJob>,
        confirmAction: @escaping() -> Void
        
    ) {
        self.store = store
        self.confirmAction = confirmAction
    }
    
    
    public var body: some View {
        ZStack {
            store.backGroudColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    signUpJobTitle()
                    
                    
                    signUpJobSelect()
                    
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.145)
                    
                    CustomButton(
                        action: {
                            confirmAction()
                        }, title: store.presntNextViewButtonTitle,
                        config: CustomButtonConfig.create()
                        ,isEnable: store.enableButton
                    )
                    .padding(.horizontal, 20)
                    .offset(y: 4)
                    
                    Spacer()
                        .frame(height: 16)
                }
                .bounce(false)
            }
            
        }
        .onAppear {
            store.send(.async(.fetchSignUpJobList))
        }
        .task {
            store.send(.async(.fetchSignUpJobList))
            store.send(.appearName(store.signUpName ?? ""))
        }
        .onTapGesture {
            store.send(.view(.closePopUp))
        }
        
    }
}


extension SignUpJobView {
    
    @ViewBuilder
    private func  signUpJobTitle() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight * 0.015)
            
            Text(store.signUpJobTitle)
                .pretendardFont(family: .SemiBold, size: 24)
                .foregroundStyle(Color.basicWhite)
            
            Spacer()
                .frame(height: 16)
            
            Text(store.signUpJobSubTitle)
                .pretendardFont(family: .Regular, size: 16)
                .foregroundStyle(Color.gray300)
            
           
        }
    }
    
    @ViewBuilder
    private func signUpJobSelect() -> some View {
        VStack {
            Spacer()
                .frame(height: 40)
            
            ScrollView {
                VStack(spacing: 12) {
                    if let categories = store.signUpJobModel?.data?.data {
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
            Spacer(minLength: padding)
            ForEach(startIndex..<endIndex, id: \.self) { index in
                signUpSelectButton(jobTitle: categories[index], width: calculateWidth(for: categories[index]))
            }
            Spacer(minLength: padding)
        }
    }
    
    @ViewBuilder
    private func signUpSelectButton(
        jobTitle: String,
        width: CGFloat
    ) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(store.selectedJob == jobTitle ? Color.basicPrimary : Color.gray500)
            .frame(width: width, height: 38)
            .overlay {
                Text(jobTitle)
                    .pretendardFont(family: .Regular, size: 18)
                    .foregroundStyle(store.selectedJob == jobTitle ? Color.gray600 : Color.gray100)
                    .foregroundStyle(Color.gray100)
            }
            .onTapGesture {
                store.send(.view(.selectJob(jobTitle)))
            }
    }
    
    func calculateWidth(for title: String) -> CGFloat {
      let baseWidth: CGFloat = 60
      let extraWidthPerCharacter: CGFloat = 10
      
      if title.count <= 2 {
        return baseWidth
      } else if title.count == 4 {
        return baseWidth + 30
      } else if title.count == 5 {
        return baseWidth + 40
      }
      else {
        return baseWidth + extraWidthPerCharacter * CGFloat(title.count - 2)
      }
    }
}
