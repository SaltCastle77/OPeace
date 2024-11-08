//
//  ReportView.swift
//  Presentation
//
//  Created by 서원지 on 8/26/24.
//

import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct ReportView: View {
    @Bindable var store: StoreOf<Report>
    var backAction: () -> Void = { }
    
    public init(
        store: StoreOf<Report>,
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
                
                CustomTitleNaviagionBackButton(buttonAction: backAction, title: "신고하기")
                
                ScrollView {
                    reportTitleView()
                    
                    reportReasonTextFieldView()
                    
                    
                }
                .bounce(false)
              
              Spacer()
              
              CustomButton(
                  action: {
                      store.send(.async(.reportQuestion(questionID: store.questionID, reason: store.reportReasonText)))
                  }, title: store.reportButtonComplete,
                  config: CustomButtonConfig.create()
                  ,isEnable: !store.reportReasonText.isEmpty
              )
              .padding(.horizontal, 20)
                
              Spacer()
                  .frame(height: 16)
              
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}


extension ReportView {
    
    @ViewBuilder
    private func reportTitleView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            HStack {
                Text("신고 사유를 작성해주세요")
                    .pretendardFont(family: .Bold, size: 16)
                    .foregroundStyle(Color.basicWhite)
                
                Spacer()
            }
            
          Spacer()
            .frame(height: 20)
          
          
          HStack {
              Text("신고 내용은 24시간 이내 조치됩니다.")
                  .pretendardFont(family: .Bold, size: 16)
                  .foregroundStyle(Color.basicWhite)
                  
              Spacer()
          }
          
          Spacer()
            .frame(height: 3)
          
          HStack {
            Text("누적 신고횟수가 3회 이상인 유저는 글 작성을 할 수 없게 됩니다.")
              .pretendardFont(family: .Bold, size: 16)
              .foregroundStyle(Color.basicWhite)
              
          Spacer()
          }
          
          Spacer()
            .frame(height: 10)
          
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func reportReasonTextFieldView() -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            TextEditor(text: $store.reportReasonText)
                .modifier(TextEditorModifier(placeholder: "여기를 눌러서 작성해주세요. 부적절하거나 불쾌감을 줄수있는 컨텐츠는 재재 받을수 있습니다", text: $store.reportReasonText))
                .frame(height: 160)
            
        }
        .padding(.horizontal, 20)
    }
}
