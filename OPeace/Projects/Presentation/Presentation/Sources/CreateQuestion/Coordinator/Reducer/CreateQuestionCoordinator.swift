//
//  CreateQuestionCoordinator.swift
//  Presentation
//
//  Created by 서원지 on 10/1/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators
import Networkings

@Reducer
public struct CreateQuestionCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var routes: [Route<CreateQuestionScreen.State>]
        
        
        @Shared(.inMemory("createQuestionUserModel")) var createQuestionUserModel: CreateQuestionUserModel = .init()
        
        
        var writeAnswer = WriteAnswer.State(createQuestionUserModel: .init())
        var writeQuestion = WriteQuestion.State()
       
        
        public init() {
            self.routes = [.root(.writeQuestion(.init()), embedInNavigationView: true)]
        }
        
    }
    
    public enum Action: ViewAction {
        case router(IndexedRouterActionOf<CreateQuestionScreen>)
        case removeView
        case presntHome
        case writeAnswer(WriteAnswer.Action)
        case writeQuestion(WriteQuestion.Action)
        case view(View)
        case navigation(NavigationAction)
        
    }
    
    @CasePathable
    public enum View {
        case removeView
    }
    
    public enum NavigationAction {
        case presntHome
    }
    
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(let routeAction):
                return routerAction(state: &state, action: routeAction)
                
            case .view(let ViewAction):
                switch ViewAction {
                case .removeView:
                    return .routeWithDelaysIfUnsupported(state.routes, action: \.router) {
                        $0.goBack()
                    }
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                case .presntHome:
                    return .none
                }
                
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
        Scope(state: \.writeAnswer, action: \.writeAnswer) {
            WriteAnswer()
        }
        Scope(state: \.writeQuestion, action: \.writeQuestion) {
            WriteQuestion()
        }
    }
    
    private func routerAction(
            state: inout State,
            action: IndexedRouterActionOf<CreateQuestionScreen>
    ) -> Effect<Action> {
        switch action {
        case .routeAction(id: _, action: .writeQuestion(.navigation(.presntWriteAnswer))):
            state.routes.push(.writeAnswer(.init(createQuestionUserModel: state.createQuestionUserModel)))
            return .none
            
        case .routeAction(id: _, action: .writeAnswer(.navigation(.presntMainHome))):
            return .send(.navigation(.presntHome))
            
        default:
            return .none
        }
    }
}


extension CreateQuestionCoordinator {
    
    @Reducer(state: .equatable)
    public enum CreateQuestionScreen {
        case writeQuestion(WriteQuestion)
        case writeAnswer(WriteAnswer)
//        case mainHome(HomeCoordinator)
    }
}
