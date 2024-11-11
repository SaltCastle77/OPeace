//
//  HomeFilter.swift
//  Presentation
//
//  Created by 염성훈 on 8/25/24.
//

import Foundation
import ComposableArchitecture

import Utill
import Networkings

@Reducer
public struct HomeFilter  {
  public init() {}
  
  @ObservableState
  public struct State : Equatable {

    public var selectedItem: String? = nil
    
    var jsobListModel: SignUpListDTOModel? = nil
    var generationListModel: GenerationListResponse? = nil
    public var homeFilterTypeState: HomeFilterEnum? = nil
    

    
    public init(homeFilterEnum: HomeFilterEnum) {
      homeFilterTypeState = homeFilterEnum
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
    case tapSettintitem(HomeFilterEnum)
  }
  
  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case fetchListByFilterEnum(HomeFilterEnum)
    case fetchJobList
    case fetchJobResponse(Result<SignUpListDTOModel, CustomError>)
    case fetchGenerationResponse(Result<GenerationListResponse, CustomError>)
  }
  
  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
  }
  
  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    
  }
  
  struct HomeFilterCancel: Hashable {}
  
  @Dependency(SignUpUseCase.self) var signUpUseCase
  @Dependency(\.mainQueue) var mainQueue
  
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce{ state, action  in
      switch action {
      case .binding(\.selectedItem):
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
    .onChange(of: \.selectedItem) { oldValue, newValue in
      Reduce { state, action in
        state.selectedItem = newValue
        return .none
      }
    }
  }
  
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
    case .tapSettintitem(let homefilter):
      state.homeFilterTypeState = homefilter
      return .none
    }
  }
  
  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchListByFilterEnum(let homeFilterType):
      state.homeFilterTypeState = homeFilterType
      switch homeFilterType {
      case .job:
        return .run {   send in
          let result = await Result {
            try await self.signUpUseCase.fetchJobList()
          }
          
          switch result  {
          case .success(let data):
            if let data  = data {
              await send(.async(.fetchJobResponse(.success(data))))
            }
          case .failure(let error):
            await send(.async(.fetchJobResponse(.failure(CustomError.map(error)))))
          }
        }
        .debounce(id: HomeFilterCancel(), for: 0.1, scheduler: mainQueue)
      case .generation:
        return .run { send in
          let result = await Result {
            try await self.signUpUseCase.fetchGenerationList()
          }
          
          switch result {
          case .success(let data):
            if let data = data {
              await send(.async(.fetchGenerationResponse(.success(data))))
            }
          case .failure(let error):
            await send(.async(.fetchGenerationResponse(.failure(CustomError.map(error)))))
          }
        }
        .debounce(id: HomeFilterCancel(), for: 0.1, scheduler: mainQueue)
      default:
        return .none
      }
      
    case .fetchJobList:
      return .run {  send in
        let result = await Result {
          try await self.signUpUseCase.fetchJobList()
        }
        
        switch result  {
        case .success(let data):
          if let data  = data {
            await send(.async(.fetchJobResponse(.success(data))))
          }
        case .failure(let error):
          await send(.async(.fetchJobResponse(.failure(CustomError.map(error)))))
        }
        
      }
      .debounce(id: HomeFilterCancel(), for: 0.1, scheduler: mainQueue)
      
    case .fetchJobResponse(let result):
      switch result {
      case .success(let data):
        state.jsobListModel  = data
      case .failure(let error):
        #logNetwork("JobList 에러", error.localizedDescription)
      }
      return .none
      
    case .fetchGenerationResponse(let result):
      switch result {
      case .success(let data):
        state.generationListModel = data
      case .failure(let error):
        #logNetwork("generationList 에러", error.localizedDescription)
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
}
