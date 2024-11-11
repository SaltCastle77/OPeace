//
//  SignUpAge.swift
//  Presentation
//
//  Created by 서원지 on 7/26/24.
//

import Foundation
import ComposableArchitecture

import Utill
import SwiftUI

import DesignSystem
import Networkings

@Reducer
public struct SignUpAge {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    
    var signUpAgeTitle: String = "나이 입력"
    var signUpAgeSubTitle: String = "출생 연도를  알려주세요"
    var signUpAgeDisplay = ""
    var signUpAgeDisplayColor: Color = Color.gray500
    var checkGenerationTextColor: Color = Color.gray500
    var checkGenerationText: String = "기타세대"
    var isErrorGenerationText: String = ""
    var presntNextViewButtonTitle = "다음"
    var enableButton: Bool = false
    var signUpName: String? = nil
    var signUpNames: String = ""
    
    var chekcGenerationModel: SignUpCheckInfoDTOModel? = nil
    @Presents var destination: Destination.State?
    var activeMenu: SignUpTab = .signUpName
    var signUpJob = SignUpJob.State()
    
    public init(
      signUpName: String? = nil
    ) {
      self.signUpName = signUpName
    }
  }
  
  public enum Action: ViewAction, FeatureAction , BindableAction, FeatureScopeAction {
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
    case switchTabs
    //        case apperName
    case scope(ScopeAction)
    case signUpJob(SignUpJob.Action)
  }
  
  @CasePathable
  public enum View {
    case apperName
    case updateGeneration(generation: String)
  }
  
  
  
  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case fetchJobList
    case updateName
    case checkGeneration(year: Int)
    case chekcGenerationResponse(Result<SignUpCheckInfoDTOModel, CustomError>)
  }
  
  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    
  }
  
  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    
  }
  
  public enum ScopeAction: Equatable {
    case fetchJobList
    
  }
  
  @Reducer(state: .equatable)
  public enum Destination {
    case signUpJob(SignUpJob)
  }
  
  struct SignUpAgeCancel: Hashable {}
  
  @Dependency(SignUpUseCase.self) var signUpUseCase
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.continuousClock) var clock
  
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .switchTabs:
        state.destination = .signUpJob(.init())
        return .none
        
      case .binding(\.signUpAgeDisplay):
        return .none
        
      case .destination(_):
        return .none
        
      case .view(let viewAction):
        return handleViewAction(state: &state, action: viewAction)
        
      case .async(let asyncAction):
        return handleAsyncAction(state: &state, action: asyncAction)
        
      case .inner(let innerAction):
        return handleInnerAction(state: &state, action: innerAction)
        
      case .navigation(let navigationAction):
        return handleNavigationAction(state: &state, action: navigationAction)
        
      case .scope(let scopeAction):
        return handleScopeAction(state: &state, action: scopeAction)
        
      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
    Scope(state: \.signUpJob, action: \.signUpJob) {
      SignUpJob()
    }
  }
  
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
    case .apperName:
      return .none
      
    case .updateGeneration(generation: let generation):
      let (color, textColor) = CheckRegister.getGenerationSignUp(
        generation: generation,
        color: state.signUpAgeDisplayColor,
        textColor: state.checkGenerationTextColor)
      //                        store.checkGenerationText = generation
      state.signUpAgeDisplayColor = color
      state.checkGenerationTextColor = textColor
      return .none
    }
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchJobList:
      return .run {  send in
        await send(.signUpJob(.fetchJob))
      }
      
    case .updateName:
      let signUpName = state.signUpName
      return .run {  send in
        await send(.signUpJob(.appearName(signUpName ?? "")))
      }
      
    case .checkGeneration(year: let year):
      var checkGenerationText = state.checkGenerationText
      var signUpAgeDisplayColor = state.signUpAgeDisplayColor
      var checkGenerationTextColor = state.checkGenerationTextColor
      return .run {  send in
        let checkGenerationResult = await Result {
          try await signUpUseCase.checkGeneration(year: year)
        }
        
        switch checkGenerationResult {
        case .success(let checkGenerationData):
          if let checkGenerationData = checkGenerationData {
            await send(.async(.chekcGenerationResponse(.success(checkGenerationData))))
            
            await send(.view(.updateGeneration(generation: checkGenerationData.data.message)))
            
          }
        case .failure(let error):
          await send(.async(.chekcGenerationResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
        }
      }
      .debounce(id: SignUpAgeCancel(), for: 0.3, scheduler: mainQueue)
      
    case .chekcGenerationResponse(let result):
      switch result {
      case .success(let checkGenrationResult):
        state.chekcGenerationModel = checkGenrationResult
        state.checkGenerationText = checkGenrationResult.data.message
        //                        state.checkGenerationText = checkGenrationResult.data?.data
      case .failure(let error):
        Log.error("세대 확인 에러", error.localizedDescription)
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
      
    }
  }
  
  private func handleScopeAction(
    state: inout State,
    action: ScopeAction
  ) -> Effect<Action> {
    switch action {
    case .fetchJobList:
      return .run {  send in
        await send(.signUpJob(.fetchJob))
      }
    }
  }
}
