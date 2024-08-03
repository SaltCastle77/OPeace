//
//  SettingView.swift
//  Presentation
//
//  Created by 서원지 on 8/1/24.
//

import Foundation
import SwiftUI
import DesignSystem

import ComposableArchitecture
import Model

public struct SettingView: View {
    @Bindable var store: StoreOf<Setting>
    private var action: () -> Void = {}
    private var closeModalAction: () -> Void = { }
    
    public init(
        store: StoreOf<Setting>,
        action: @escaping () -> Void,
        closeModalAction: @escaping () -> Void
    ) {
        self.store = store
        self.action = action
        self.closeModalAction = closeModalAction
    }
    
    public var body: some View {
        ZStack {
            Color.gray500
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Spacer()
                    .frame(height: 32)
                
                settingList()
                
                
                Spacer()
                
            }
        }
    }
    
}


extension SettingView {
    
    @ViewBuilder
    private func settingList() -> some View {
        VStack {
            ForEach(SettingProfile.allCases, id: \.self) { item in
                settingListitem(title: item.desc) {
                    store.send(.view(.tapSettintitem(item)))
                    if item == store.settingtitem {
                        switch store.settingtitem {
                        case .editProfile:
                            closeModalAction()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                action()
                            }
                        case .blackManagement:
                            print(item.desc)
                        case .logout:
                            closeModalAction()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                action()
                            }
                        case .withDraw:
                            print(item.desc)
                        case .none:
                            print(item.desc)
                        }
                    }
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func settingListitem(
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
