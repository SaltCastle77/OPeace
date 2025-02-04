//
//  Profile.swift
//  Presentation
//
//  Created by 서원지 on 7/31/24.
//

import SwiftUI

import ComposableArchitecture

import Utill
import DesignSystem
import Networkings

import KakaoSDKAuth
import KakaoSDKUser

@Reducer
public struct Profile {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var profileGenerationColor: Color = Color.gray600
    var profileGenerationTextColor: Color = Color.gray600
    var profileGenerationText: String = ""
    
    public var profileUserModel: UpdateUserInfoDTOModel? = nil
    var userLogoutModel: UserDTOModel? = nil
    var myQuestionListModel: QuestionDTOModel?  = nil
    var deleteQuestionModel: FlagQuestionDTOModel? = nil
    var statusQuestionModel: StatusQuestionDTOModel? = nil
    
    var profileGenerationYear: Int? = .zero
    var logoutPopUpTitle: String = "로그아웃 하시겠어요?"
    var deletePopUpTitle: String = "정말 탈퇴하시겠어요?"
    var isLogOutPopUp: Bool = false
    var isDeleteUserPopUp: Bool = false
    var isDeleteQuestionPopUp: Bool = false
    var popUpText: String = ""
    
    var cardGenerationColor: Color = .basicBlack
    var deleteQuestionId: Int = .zero
    var questionId: Int = .zero
    
    @Presents var destination: Destination.State?
    @Shared(.inMemory("userInfoModel")) var userInfoModel: UserInfoModel? = .init()
    @Shared(.appStorage("lastViewedPage")) var lastViewedPage: Int = .zero
    
    public init() {}
  }
  
  public indirect enum Action: ViewAction, BindableAction, FeatureAction {
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)
    case scopeFetchUser
  }
  
  @Reducer(state: .equatable)
  public enum Destination {
    case setting(Setting)
    case popup(CustomPopUp)
    case home(Home)
  }
  
  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case tapPresntSettingModal
    case closeModal
    case presntPopUp
    case closePopUp
    case updateGenerationInfo
    case switchModalAction(SettingProfile)
    case contartEmail
    
  }
  
  
  
  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case fetchUserProfileResponse(Result<UpdateUserInfoDTOModel, CustomError>)
    case fetchUser
    case logoutUseResponse(Result<UserDTOModel, CustomError>)
    case logoutUser
    case socilalLogOutUser
    case fetchQuestionResponse(Result<QuestionDTOModel, CustomError>)
    case fetchQuestion
    case deleteQuestion(questionID: Int)
    case deleteQuestionResponse(Result<FlagQuestionDTOModel, CustomError>)
    case statusQuestion(id: Int)
    case statusQuestionResponse(Result<StatusQuestionDTOModel, CustomError>)
    
  }
  
  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
    
  }
  
  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case presntLogout
    case presntEditProfile
    case presntWithDraw
    case presnetCreateQuestionList
    case presntDeleteQuestion
    case presntUserBlock
    
  }
  
  @Dependency(AuthUseCase.self) var authUseCase
  @Dependency(QuestionUseCase.self) var questionUseCase
  @Dependency(\.continuousClock) var clock
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(_):
        return .none
        
      case .scopeFetchUser:
        state.userInfoModel?.isChangeProfile = false
        return .run {  send in
          await send(.async(.fetchUser))
        }
        
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
        
      }
    }
    .ifLet(\.$destination, action: \.destination)
    .onChange(of: \.myQuestionListModel) { oldValue, newValue in
      Reduce { state, action in
        state.myQuestionListModel = newValue
        return .none
      }
    }
    .onChange(of: \.statusQuestionModel) { oldValue, newValue in
      Reduce { state, action in
        state.statusQuestionModel = newValue
        return .none
      }
    }
    .onChange(of: \.userInfoModel) { oldValue, newValue in
      Reduce { state, action in
        state.userInfoModel = newValue
        return .none
      }
    }
  }
  
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
    case .tapPresntSettingModal:
      state.destination = .setting(.init())
      return .none
      
    case .closeModal:
      state.destination = nil
      return .none
      
    case .presntPopUp:
      state.destination = .popup(.init())
      return .none
      
    case .closePopUp:
      state.destination = nil
      return .none
      
    case .updateGenerationInfo:
      let (generation, color, textColor) = CheckRegister.getGeneration(
        year: state.profileGenerationYear ?? .zero,
        color: state.profileGenerationColor,
        textColor: state.profileGenerationTextColor
      )
      state.profileGenerationText = generation
      state.profileGenerationColor = color
      state.profileGenerationTextColor = textColor
      
      return .none
      
    case .switchModalAction(let settingprofile):
      nonisolated(unsafe) var settingProfile = settingprofile
      switch settingProfile {
      case .editProfile:
        Log.debug("프로필 수정")
      case .blackManagement:
        Log.debug("차단")
      case .logout:
        state.popUpText = "로그아웃 하시겠어요?"
        state.isLogOutPopUp = true
      case .withDraw:
        state.popUpText = "정말 탈퇴하시겠어요?"
        state.isDeleteUserPopUp = true
      case .contactUs:
        break
      }
      return .run { send in
        switch settingProfile {
        case .editProfile:
          await send(.navigation(.presntEditProfile))
        case .blackManagement:
          Log.debug("차단")
          await send(.navigation(.presntUserBlock))
        case .logout:
          await send(.view(.presntPopUp))
        case .withDraw:
          await send(.view(.presntPopUp))
        case .contactUs:
          await send(.view(.contartEmail))
        }
        
      }
      
    case .contartEmail:
      if let subject = "문의/신고하기".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
         let body = """
            아래 내용을 적어주세요. 빠르게 답변 드리겠습니다.\n
            • 이용 중인 기기/OS 버전:\n
            • 닉네임: \n
            • 문의 내용:
            """.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
         let url = URL(string: "mailto:suhwj81@gmail.com?subject=\(subject)&body=\(body)") {
        
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
      return .none
    }
  }
  
  
  
  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
    case .fetchUser:
      return .run { send in
        let fetchUserData = await Result {
          try await authUseCase.fetchUserInfo()
        }
        
        switch fetchUserData {
        case .success(let fetchUserResult):
          if let fetchUserResult = fetchUserResult {
            await send(.async(.fetchUserProfileResponse(.success(fetchUserResult))))
            await send(.view(.updateGenerationInfo))
          }
        case .failure(let error):
          await send(.async(.fetchUserProfileResponse(.failure(CustomError.map(error)))))
          
        }
      }
      
    case .fetchUserProfileResponse(let result):
      switch result {
      case .success(let resultData):
        state.profileUserModel = resultData
        state.profileGenerationYear =  state.profileUserModel?.data.year
        state.userInfoModel?.isChangeProfile = false
        
      case let .failure(error):
        #logNetwork("프로필 오류", error.localizedDescription)
      }
      return .none
      
    case .socilalLogOutUser:
      let socialType = UserDefaults.standard.string(forKey: "LoginSocialType") ?? ""
      return .run {  send in
        switch socialType {
        case "kakao":
          await send(.async(.logoutUser))
          
        case "apple":
          await send(.async(.logoutUser))
        default:
          break
        }
      }
      
    case .logoutUseResponse(let result):
      switch result{
      case .success(let userData):
        state.userLogoutModel = userData
        #logDebug("유저 로그아웃 성공", userData)
        state.userInfoModel?.isLogOut = true
        state.destination = .home(.init(userInfoModel: state.userInfoModel))
      case .failure(let error):
        #logDebug("유저 로그아웃 에러", error.localizedDescription)
      }
      return .none
      
    case .logoutUser:
      nonisolated(unsafe) var userinfoModel = state.userInfoModel
      return .run {  send in
        let userLogOutData = await Result {
          try await authUseCase.logoutUser(refreshToken: "")
        }
        
        switch userLogOutData {
        case .success(let userLogOutData):
          if let userLogOutData = userLogOutData {
            await send(.async(.logoutUseResponse(.success(userLogOutData))))
            UserDefaults.standard.removeObject(forKey: "ACCESS_TOKEN")
            let loginSocialType = UserDefaults.standard.removeObject(forKey: "LoginSocialType")
            await send(.view(.closePopUp))
            userinfoModel?.isLogOut = true
            try await self.clock.sleep(for: .seconds(0.4))
            await send(.navigation(.presntLogout))
          }
          
        case .failure(let error):
          await send(.async(.logoutUseResponse(.failure(CustomError.map(error)))))
        }
      }
      
      
    case .fetchQuestion:
      return .run {  send in
        let questionResult = await Result {
          try await questionUseCase.myQuestionList(page: 1, pageSize: 20)
        }
        
        switch questionResult {
        case .success(let questionResult):
          if let questionData = questionResult {
            await  send(.async(.fetchQuestionResponse(.success(questionData))))
          }
        case .failure(let error):
          await send(.async(.logoutUseResponse(.failure(
            CustomError.encodingError(error.localizedDescription)))))
        }
      }
      
    case .fetchQuestionResponse(let result):
      switch result {
      case .success(let questionData):
        state.myQuestionListModel = questionData
        
      case .failure(let error):
        Log.debug("피드 목록 에러", error.localizedDescription)
      }
      return .none
      
    case .deleteQuestion(let questionID):
      return .run { send in
        let deleteQuestionResult = await Result {
          try await questionUseCase.deleteQuestion(questionID: questionID)
        }
        
        switch deleteQuestionResult {
        case .success(let deleteQuestionResult):
          if let deleteQuestionResult = deleteQuestionResult {
            await send(.async(.deleteQuestionResponse(.success(deleteQuestionResult))))
            
            try await self.clock.sleep(for: .seconds(1))
            await  send(.navigation(.presntDeleteQuestion))
          }
        case .failure(let error):
          await send(.async(.deleteQuestionResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
        }
      }
      
    case .deleteQuestionResponse(let result):
      switch result {
      case .success(let deleteQuestionData):
        state.deleteQuestionModel = deleteQuestionData
        state.userInfoModel?.isDeleteQuestion = true
        
      case .failure(let error):
        #logDebug("질문 삭제 에러", error.localizedDescription)
      }
      return .none
      
    case .statusQuestion(id: let id):
      return .run { send in
        let questionResult = await Result {
          try await questionUseCase.statusQuestion(questionID: id)
        }
        
        switch questionResult {
        case .success(let questionStatusData):
          if let questionStatusData = questionStatusData {
            await send(.async(.statusQuestionResponse(.success(questionStatusData))))
          }
        case .failure(let error):
          await send(.async(.statusQuestionResponse(.failure(CustomError.encodingError(error.localizedDescription)))))
        }
      }
      
    case .statusQuestionResponse(let result):
      switch result {
      case .success(let statusQuestionData):
        state.statusQuestionModel = statusQuestionData
      case .failure(let error):
        #logDebug("질문 에대한 결과 보여주기 실패", error.localizedDescription)
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
    case .presntLogout:
      return .none
      
    case .presntEditProfile:
      return .none
      
    case .presntWithDraw:
      return .none
      
    case .presnetCreateQuestionList:
      return .none
      
    case .presntDeleteQuestion:
      return .none
      
    case .presntUserBlock:
      return .none
    }
  }
}
