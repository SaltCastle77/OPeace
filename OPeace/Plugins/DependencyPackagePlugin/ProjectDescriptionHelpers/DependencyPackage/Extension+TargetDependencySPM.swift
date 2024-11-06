//
//  Extension+TargetDependencySPM.swift
//  DependencyPackagePlugin
//
//  Created by 서원지 on 4/19/24.
//

import ProjectDescription

public extension TargetDependency.SPM {
    static let composableArchitecture = TargetDependency.external(name: "ComposableArchitecture", condition: .none)
  static let asyncMoya = TargetDependency.external(name: "AsyncMoya", condition: .none)
  
    static let concurrencyExtras = TargetDependency.external(name: "ConcurrencyExtras", condition: .none)
    static let sdwebImage = TargetDependency.external(name: "SDWebImageSwiftUI", condition: .none)
    static let keychainAccess = TargetDependency.external(name: "KeychainAccess", condition: .none)
    static let collections = TargetDependency.external(name: "Collections", condition: .none)
    static let kakaoSDKAuth = TargetDependency.external(name: "KakaoSDKAuth", condition: .none)
    static let kakaoSDKUser = TargetDependency.external(name: "KakaoSDKUser", condition: .none)
    static let kakaoSDKCommon = TargetDependency.external(name: "KakaoSDKCommon", condition: .none)
    
    static let popupView = TargetDependency.external(name: "PopupView", condition: .none)
    
    static let firebaseAuth = TargetDependency.external(name: "FirebaseAuth", condition: .none)
    static let firebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics", condition: .none)
    static let firebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics", condition: .none)
    static let swiftUIIntrospect = TargetDependency.external(name: "SwiftUIIntrospect", condition: .none)
    static let isEmojiView = TargetDependency.external(name: "ISEmojiView", condition: .none)
    static let swiftJWT = TargetDependency.external(name: "SwiftJWT", condition: .none)
    static let tcaCoordinator = TargetDependency.external(name: "TCACoordinators", condition: .none)
  
}
  

