//
//  EditQuestionView.swift
//  Presentation
//
//  Created by 서원지 on 8/25/24.
//

import SwiftUI
import ComposableArchitecture

import DesignSystem
import Utills

public struct EditQuestionView: View {
    @Bindable var store: StoreOf<EditQuestion>
    private var action: () -> Void = {}
    private var closeModalAction: () -> Void = { }
    
    public init(
        store: StoreOf<EditQuestion>,
        action: @escaping () -> Void,
        closeModalAction: @escaping () -> Void
    ) {
        self.store = store
        self.action = action
        self.closeModalAction = closeModalAction
    }
    
    public var body: some View  {
        ZStack {
            Color.gray500
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Spacer()
                    .frame(height: 32)
                
                editQustionList()
                
                Spacer()
            }
        }
    }
}


extension EditQuestionView {
    
    @ViewBuilder
    private func editQustionList() -> some View {
        VStack {
            ForEach(EditQuestionType.allCases, id: \.self) {
                 item in
                editQustionListitem(title: item.editQuestionDesc) {
                    store.send(.view(.tapEditQuestionitem(item)))
                    if item == store.editQuestionitem {
                        switch store.editQuestionitem {
                        case .reportUser:
                            closeModalAction()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                action()
                            }
                        case .blockUser:
                            closeModalAction()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                action()
                            }
                        case .none:
                            Log.debug(item.editQuestionDesc)
                            
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func editQustionListitem(
        title : String,
        completion: @escaping () -> Void
    ) -> some View {
        VStack {
            
            HStack {
                Text(title)
                    .pretendardFont(family: .SemiBold, size: 20)
                    .foregroundStyle(Color.basicWhite)
                    .onTapGesture {
                        completion()
                    }
                
                Spacer()
                
            }
            .padding(.horizontal, 32)
            
        }
        .padding(.vertical, 14)
        
        Spacer()
            .frame(height: 4)
    }
}
