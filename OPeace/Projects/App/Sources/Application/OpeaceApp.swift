import SwiftUI
import ComposableArchitecture
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct OpeaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var isFirstUseApp = UserDefaults.standard.bool(forKey: "isFirstTimeUser")
    
    init() {
        registerDependencies()
        initializeKakao()
        isFirstApplication()
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(
                store:
                    Store(
                        initialState: AppReducer.State(),
                        reducer: {
                            AppReducer()
                                ._printChanges()
                                ._printChanges(.actionLabels)
                                ._printChanges(.customDump)
                        }
                    )
            )
            .onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
    }
}

extension OpeaceApp {
    private func registerDependencies() {
        Task {
            await AppDIContainer.shared.registerDependencies()
        }
    }
    
    private func initializeKakao() {
        guard let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String else {
            return
        }
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
    
    private func isFirstApplication() {
        print("isFirstUseApp : \(isFirstUseApp)")
        if isFirstUseApp == false {
          UserDefaults.standard.removeObject(forKey: "isFirstUseApp")
        }
    }
}
