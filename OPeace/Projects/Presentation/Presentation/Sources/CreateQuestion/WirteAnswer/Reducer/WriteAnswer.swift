//
//  WriteAnswer.swift
//  Presentation
//
//  Created by 서원지 on 8/15/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture

import Utill
import DesignSystem
import Networkings

@Reducer
public struct WriteAnswer {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    //        @Shared var createQuestionEmoji: String
    //        @Shared var createQuestionTitle: String
    
    @Shared var createQuestionUserModel: CreateQuestionUserModel
    
    @Shared(.inMemory("userInfoModel")) var userInfoModel: UserInfoModel? = .init()
    
    @Presents var destination: Destination.State?
    
    var presntWriteUploadViewButtonTitle: String = "고민 올리기"
    var enableButton: Bool = false
    var choiceAtext: String = ""
    var choiceBtext: String = ""
    var floatinPopUpText: String = ""
    var isErrorEnableAnswerAStroke: Bool = false
    var isErrorEnableAnswerBStroke: Bool = false
    
    var createQuesionModel: CreateQuestionDTOModel?  = nil
    
    
    public init(
      createQuestionUserModel: CreateQuestionUserModel = .init()
    ) {
      self._createQuestionUserModel = Shared(wrappedValue: createQuestionUserModel, .inMemory("createQuestionUserModel"))
      
    }
  }
  
  public enum Action: ViewAction, BindableAction, FeatureAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
  }
  
  @Reducer(state: .equatable)
  public enum Destination {
    case floatingPopUP(FloatingPopUp)
    
  }
  
  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case presntFloatintPopUp
    case closePopUp
    case timeToCloseFloatingPopUp
  }
  
  
  
  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case createQuestion(emoji: String, title: String, choiceA: String, choiceB: String)
    case createQuestionResponse(Result<CreateQuestionDTOModel, CustomError>)
  }
  
  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    
  }
  
  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case presntMainHome
    
  }
  
  @Dependency(\.continuousClock) var clock
  @Dependency(QuestionUseCase.self) var questionUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .binding(\.choiceAtext):
        return .none
        
      case .binding(\.choiceBtext):
        return .none
        
      case .binding(\.isErrorEnableAnswerAStroke):
        return .none
        
      case .binding(\.isErrorEnableAnswerBStroke):
        return .none
        
      case .destination(_):
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
    .ifLet(\.$destination, action: \.destination)
  }
  
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
    case .presntFloatintPopUp:
      state.destination = .floatingPopUP(.init())
      return .none
      
    case .closePopUp:
      state.destination = nil
      return .none
      
    case .timeToCloseFloatingPopUp:
      return .run { send in
        try await clock.sleep(for: .seconds(1.5))
        await send(.view(.closePopUp))
      }
    }
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .createQuestion(
      let emoji,
      let title,
      let choiceA,
      let choiceB):
      return .run {  send in
        let createResult = await Result {
          try await questionUseCase.createQuestion(
            emoji: emoji,
            title: title,
            choiceA: choiceA,
            choiceB: choiceB
          )
        }
        
        switch createResult {
        case .success(let createResultData):
          if let createResultData = createResultData {
            await send(.async(.createQuestionResponse(.success(createResultData))))
            
            if createResultData.data.id != .zero  {
              await send(.navigation(.presntMainHome))
            }
          }
        case .failure(let error):
          await send(.async(.createQuestionResponse(.failure(CustomError.createQuestionError(error.localizedDescription)))))
        }
        
      }
    case .createQuestionResponse(let result):
      switch result {
      case .success(let createResultData):
        state.createQuesionModel = createResultData
        state.createQuestionUserModel.createQuestionEmoji = ""
        state.createQuestionUserModel.createQuestionTitle = ""
      case .failure(let error):
        #logError("질문 생성 실패", error.localizedDescription)
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
