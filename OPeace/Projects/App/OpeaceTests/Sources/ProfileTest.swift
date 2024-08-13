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


@MainActor
struct ProfileTest {
    let store = TestStore(initialState: Profile.State()) {
        Profile()
    } withDependencies: {
        let repository = AuthRepository()
        $0.authUseCase = AuthUseCase(repository: repository)
    }

    @Test func testUserinfo_유저정보_조회테스트() async throws {
        // Send the action to trigger the effect
        await store.send(.async(.fetchUser))
        
        await store.finish()
        
         store.exhaustivity = .off
    }
}
