//
//  Report.swift
//  Presentation
//
//  Created by 서원지 on 8/26/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Networkings

@Reducer
public struct Report {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
       
        var reportReasonText: String = ""
        var reportButtonComplete: String = "완료"
        var reportQuestionModel: ReportQuestionModel? = nil
        
        @Shared(.inMemory("userInfoModel")) var userInfoModel: UserInfoModel? = .init()
        @Shared var questionID: Int
        
        public init(
            questionID: Int = 0
        ) {
            self._questionID = Shared(wrappedValue: questionID, .inMemory("questionID"))
        }
    }
    
    public enum Action: ViewAction, BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(View)
        case async(AsyncAction)
        case inner(InnerAction)
        case navigation(NavigationAction)
    }
    
    //MARK: - ViewAction
    @CasePathable
    public enum View {
        
    }
    
    //MARK: - AsyncAction 비동기 처리 액션
    public enum AsyncAction: Equatable {
        case reportQuestion(questionID: Int, reason: String)
        case reportQuestionResponse(Result<ReportQuestionModel, CustomError>)
    }
    
    //MARK: - 앱내에서 사용하는 액션
    public enum InnerAction: Equatable {
        
    }
    
    //MARK: - NavigationAction
    public enum NavigationAction: Equatable {
        case presntMainHome
        
    }
    
    @Dependency(QuestionUseCase.self) var questionUseCase
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.reportReasonText):
                return .none
                
            case .binding(_):
                return .none
                
                
            case .view(let View):
                switch View {
                    
                }
                
            case .async(let AsyncAction):
                switch AsyncAction {
                    
                case .reportQuestion(questionID: let questionID, reason: let reason):
                    return .run { @MainActor send in
                        let reportQuestionResult = await Result {
                            try await questionUseCase.reportQuestion(questionID: questionID, reason: reason)
                        }
                        
                        switch reportQuestionResult {
                        case .success(let reportQuestionResultData):
                            if let reportQuestionResultData = reportQuestionResultData {
                                send(.async(.reportQuestionResponse(.success(reportQuestionResultData))))
                                
                                try await clock.sleep(for: .seconds(1))
                                
                                send(.navigation(.presntMainHome))
                            }
                        case .failure(let error):
                            send(.async(.reportQuestionResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
                        }
                        
                    }
                    
                case .reportQuestionResponse(let result):
                    switch result {
                    case .success(let reportQuestionResult):
                        state.reportQuestionModel = reportQuestionResult
                        state.userInfoModel?.isReportQuestion = true
                    case .failure(let error):
                        Log.error("질문 신고 실패", error.localizedDescription)
                    }
                    return .none
                }
                
            case .inner(let InnerAction):
                switch InnerAction {
                    
                }
                
            case .navigation(let NavigationAction):
                switch NavigationAction {
                    
                case .presntMainHome:
                    return .none
                }
            }
        }
    }
}
