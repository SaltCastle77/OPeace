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
    var reportQuestionModel: FlagQuestionDTOModel? = nil
    
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
    case reportQuestionResponse(Result<FlagQuestionDTOModel, CustomError>)
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
        
        
      case .view(let viewAction):
        return handleViewAction(state: &state, action: viewAction)
        
      case .async(let asyncAction):
        return handleAsyncAction(state: &state, action: asyncAction)
        
      case .inner(let innerAction):
        return handleInnerAction(state: &state, action: innerAction)
        
      case .navigation(let navigationAction):
        return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
  }
  
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      
    }
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .reportQuestion(questionID: let questionID, reason: let reason):
      return .run { send in
        let reportQuestionResult = await Result {
          try await questionUseCase.reportQuestion(questionID: questionID, reason: reason)
        }
        
        switch reportQuestionResult {
        case .success(let reportQuestionResultData):
          if let reportQuestionResultData = reportQuestionResultData {
            await send(.async(.reportQuestionResponse(.success(reportQuestionResultData))))
            
            try await clock.sleep(for: .seconds(1))
            
            await send(.navigation(.presntMainHome))
          }
        case .failure(let error):
          await send(.async(.reportQuestionResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
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
  }
  
  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      
    }
  }
  
  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
    case .presntMainHome:
      return .none
    }
  }
}
