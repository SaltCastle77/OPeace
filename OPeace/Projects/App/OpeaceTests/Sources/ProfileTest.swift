//
//  ProfileTest.swift
//  OPeaceTests
//
//  Created by 서원지 on 8/13/24.
//

import Testing
import Presentation
import ComposableArchitecture
@testable import OPeace

import XCTest
import UseCase
import Model
import Utills


@MainActor
struct ProfileTest {
    let store = TestStore(initialState: Profile.State()) {
        Profile()
    } withDependencies: {
        let repository = AuthRepository()
        $0.authUseCase = AuthUseCase(repository: repository)
    }

    @Test("유저 정보 조회")
    func testUserInfo_유저정보_조회() async throws {
        var mockUpdateUserInfo = UpdateUserInfoModel.mockModel
        
        await store.send(.async(.fetchUserProfileResponse(.success(mockUpdateUserInfo)))) { state in
            state.profileUserModel = mockUpdateUserInfo
        }
        
        await store.send(.async(.fetchUser))
        
        store.assert { state in
            state.profileUserModel = mockUpdateUserInfo
        }
        
        let mockError = CustomError.unknownError("Failed to fetch user info")
        
      
        await store.send(.async(.fetchUserProfileResponse(.failure(mockError)))) {
            XCTAssertNil($0.profileUserModel)
        }
        

        
        await store.finish()
         store.exhaustivity = .off
    }
    
    @Test("유저 정보 업데이트")
    func testUserInfo_유저정보_업데이트() async throws {
        let testEditStore = TestStore(initialState: EditProfile.State()) {
            EditProfile()
        } withDependencies: {
            let repository = AuthRepository()
            $0.authUseCase = AuthUseCase(repository: repository)
            let signupRepository = SingUpRepository()
            $0.signUpUseCase = SignUpUseCase(repository: signupRepository)
        }
        
        await testEditStore.send(.async(.updateUserInfo(nickName: "로이", year: 1998, job: "개발", generation: "Z 세대")))
    }
}
