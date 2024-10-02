//
//  CreateQuestionCoordinatorView.swift
//  Presentation
//
//  Created by 서원지 on 10/1/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

public struct CreateQuestionCoordinatorView: View {
    @Bindable var store: StoreOf<CreateQuestionCoordinator>
    
    public init(
        store: StoreOf<CreateQuestionCoordinator>
    ) {
        self.store = store
    }
    
    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case .writeQuestion(let writeQuestionStore):
                WriteQuestionView(store: writeQuestionStore) {
                    store.send(.navigation(.presntHome))
                }
                .navigationBarBackButtonHidden()
                
            case .writeAnswer(let writeAnswerStore):
                WriteAnswerView(store: writeAnswerStore) {
                    store.send(.view(.removeView))
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
    
}
