//
//  AppDelegate.swift
//  OPeace
//
//  Created by 서원지 on 7/21/24.
//
import UIKit
import Firebase
import FirebaseRemoteConfig

class AppDelegate: UIResponder, UIApplicationDelegate {
  var remoteConfig: RemoteConfig!
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
      FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
      remoteConfig = RemoteConfig.remoteConfig()
      let settings = RemoteConfigSettings()
      settings.minimumFetchInterval = 0
      remoteConfig.configSettings = settings
      remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        return true
    }
    
  
  
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
    }
    
}
