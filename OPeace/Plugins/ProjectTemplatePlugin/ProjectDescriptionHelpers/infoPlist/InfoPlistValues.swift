//
//  InfoPlistValues.swift
//  ProjectTemplatePlugin
//
//  Created by 서원지 on 6/12/24.
//

import Foundation
import ProjectDescription

import ProjectDescription

public struct InfoPlistValues {
    public static func setUIUserInterfaceStyle(_ value: String) -> [String: Plist.Value] {
        return ["UIUserInterfaceStyle": .string(value)]
    }

    public static func setCFBundleDevelopmentRegion(_ value: String) -> [String: Plist.Value] {
        return ["CFBundleDevelopmentRegion": .string(value)]
    }

    public static func setCFBundleExecutable(_ value: String) -> [String: Plist.Value] {
        return ["CFBundleExecutable": .string(value)]
    }

    public static func setCFBundleIdentifier(_ value: String) -> [String: Plist.Value] {
        return ["CFBundleIdentifier": .string(value)]
    }

    public static func setCFBundleInfoDictionaryVersion(_ value: String) -> [String: Plist.Value] {
        return ["CFBundleInfoDictionaryVersion": .string(value)]
    }

    public static func setCFBundleName(_ value: String) -> [String: Plist.Value] {
        return ["CFBundleName": .string(value)]
    }

    public static func setCFBundlePackageType(_ value: String) -> [String: Plist.Value] {
        return ["CFBundlePackageType": .string(value)]
    }

    public static func setCFBundleShortVersionString(_ value: String) -> [String: Plist.Value] {
        return ["CFBundleShortVersionString": .string(value)]
    }

    public static func setCFBundleURLTypes(_ value: [[String: Any]]) -> [String: Plist.Value] {
        func convertToPlistValue(_ value: Any) -> Plist.Value {
            switch value {
            case let string as String:
                return .string(string)
            case let array as [Any]:
                return .array(array.map { convertToPlistValue($0) })
            case let dictionary as [String: Any]:
                return .dictionary(dictionary.mapValues { convertToPlistValue($0) })
            case let bool as Bool:
                return .boolean(bool)
            default:
                return .string("\(value)")
            }
        }
        
        return ["CFBundleURLTypes": .array(value.map { .dictionary($0.mapValues { convertToPlistValue($0) }) })]
    }

    public static func setCFBundleVersion(_ value: String) -> [String: Plist.Value] {
        return ["CFBundleVersion": .string(value)]
    }

    public static func setGIDClientID(_ value: String) -> [String: Plist.Value] {
        return ["GIDClientID": .string(value)]
    }

    public static func setLSRequiresIPhoneOS(_ value: Bool) -> [String: Plist.Value] {
        return ["LSRequiresIPhoneOS": .boolean(value)]
    }

    public static func setUIAppFonts(_ value: [String]) -> [String: Plist.Value] {
        return ["UIAppFonts": .array(value.map { .string($0) })]
    }

    public static func setAppTransportSecurity() -> [String: Plist.Value] {
        return [
            "NSAppTransportSecurity": .dictionary([
                "NSAllowsArbitraryLoads": .boolean(true)
            ])
        ]
    }
    
    public static func setApplicationQueriesSchemes() -> [String: Plist.Value] {
        return [
            "LSApplicationQueriesSchemes": .array([
                .string("kakaokompassauth"),
                .string("kakaolink"),
                .string("kakaoplus")
            ])
        ]
    }
    
  public static func setCFBundleURLTypes() -> [String: Plist.Value] {
    let kakaoAppKey = setKakaoAPPKEY("$(KAKAO_APP_KEY)").values.first
        let kakaoAppKeyValue: String
        
        if case let .string(value) = kakaoAppKey {
            kakaoAppKeyValue = value
        } else {
            kakaoAppKeyValue = "" // 기본값 설정
        }
    return [
      "CFBundleURLTypes": .array([
        .dictionary([
          "CFBundleTypeRole": .string("Editor"),
          "CFBundleURLName": .string("kakao"),
          "CFBundleURLSchemes": .array([
            .string("kakao${\(kakaoAppKeyValue)}")
          ])
        ])
      ])
    ]
  }
  
  public static func setFirebaseAnalyticsCollectionEnabled() -> [String: Plist.Value] {
      return ["FIREBASE_ANALYTICS_COLLECTION_ENABLED": .boolean(false)]
  }
    
    public static func setUIApplicationSceneManifest(_ value: [String: Any]) -> [String: Plist.Value] {
        func convertToPlistValue(_ value: Any) -> Plist.Value {
            switch value {
            case let string as String:
                return .string(string)
            case let array as [Any]:
                return .array(array.map { convertToPlistValue($0) })
            case let dictionary as [String: Any]:
                return .dictionary(dictionary.mapValues { convertToPlistValue($0) })
            case let bool as Bool:
                return .boolean(bool)
            default:
                return .string("\(value)")
            }
        }

        return ["UIApplicationSceneManifest": convertToPlistValue(value)]
    }

    public static func setUILaunchStoryboardName(_ value: String) -> [String: Plist.Value] {
        return ["UILaunchStoryboardName": .string(value)]
    }

    public static func setUIRequiredDeviceCapabilities(_ value: [String]) -> [String: Plist.Value] {
        return ["UIRequiredDeviceCapabilities": .array(value.map { .string($0) })]
    }

    public static func setUISupportedInterfaceOrientations(_ value: [String]) -> [String: Plist.Value] {
        return ["UISupportedInterfaceOrientations": .array(value.map { .string($0) })]
    }
    
    public static func setNSCameraUsageDescription(_ value: String) -> [String: Plist.Value] {
        return ["NSCameraUsageDescription": .string(value)]
    }
    
  
  // BaseURL 설정 함수 추가
  public static func setCustomValue(_ value: String) -> [String: Plist.Value] {
      return ["KAKAO_KEY": .string(value)]
  }

  public static func setKakaoAPPKEY(_ value: String) -> [String: Plist.Value] {
      let customValue = setCustomValue(value) // setCustomValue 호출
      guard let customPlistValue = customValue.values.first,
            case let .string(extractedValue) = customPlistValue else {
          return [:] // 값이 없거나 .string 타입이 아닌 경우 빈 딕셔너리 반환
      }
      
      // setCustomValue의 value 값만 반환
      return ["KAKAO_APP_KEY": .string(extractedValue)]
  }
    
    public static func setUILaunchScreens() -> [String: Plist.Value] {
        return [
            "UILaunchScreens": .dictionary([
                "UILaunchScreen": .dictionary([
                    "New item": .dictionary([
                        "UIImageName": .string(""),
                        "UILaunchScreenIdentifier": .string("")
                    ])
                ])
            ])
        ]
    }
//    App Uses Non-Exempt Encryption
    public static func setAppUseExemptEncryption(value: Bool) -> [String: Plist.Value] {
        return ["ITSAppUsesNonExemptEncryption": .boolean(value)]
    }
    
    public static func generateInfoPlist() -> [String: Plist.Value] {
        var infoPlist: [String: Plist.Value] = [:]

        infoPlist.merge(setUIUserInterfaceStyle("Dark")) { (_, new) in new }
        infoPlist.merge(setCFBundleDevelopmentRegion("$(DEVELOPMENT_LANGUAGE)")) { (_, new) in new }
        infoPlist.merge(setCFBundleExecutable("$(EXECUTABLE_NAME)")) { (_, new) in new }
        infoPlist.merge(setCFBundleIdentifier("$(PRODUCT_BUNDLE_IDENTIFIER)")) { (_, new) in new }
        infoPlist.merge(setCFBundleInfoDictionaryVersion("6.0")) { (_, new) in new }
        infoPlist.merge(setCFBundleName("OPeace")) { (_, new) in new }
        infoPlist.merge(setCFBundlePackageType("APPL")) { (_, new) in new }
        infoPlist.merge(setCFBundleShortVersionString(.appVersion(version: "1.0.0"))) { (_, new) in new }
        infoPlist.merge(setAppTransportSecurity()) { (_, new) in new }
        infoPlist.merge(setApplicationQueriesSchemes()) { (_, new) in new }
        infoPlist.merge(setCFBundleURLTypes()) { (_, new) in new }
        infoPlist.merge(setAppUseExemptEncryption(value: false)) { (_, new) in new }

        infoPlist.merge(setCFBundleVersion(.appBuildVersion())) { (_, new) in new }
        infoPlist.merge(setLSRequiresIPhoneOS(true)) { (_, new) in new }
        infoPlist.merge(setUIAppFonts(["PretendardVariable.ttf"])) { (_, new) in new }
        infoPlist.merge(setUIApplicationSceneManifest([
            "UIApplicationSupportsMultipleScenes": true,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ]
                ]
            ]
        ])) { (_, new) in new }
        infoPlist.merge(setUIRequiredDeviceCapabilities(["armv7"])) { (_, new) in new }
        infoPlist.merge(setUISupportedInterfaceOrientations(["UIInterfaceOrientationPortrait"])) { (_, new) in new }
        infoPlist.merge(setUILaunchScreens()) { (_, new) in new }
      infoPlist.merge(setCustomValue("$(KAKAO_KEY)")) { (_, new) in new }
      infoPlist.merge(setKakaoAPPKEY("$(KAKAO_KEY)")) { (_, new) in new }
        return infoPlist
    }
}
