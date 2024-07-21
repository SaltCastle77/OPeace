import SwiftUI
import ComposableArchitecture


@main
struct OpeaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        registerDependencies()
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
                        }
                    )
            )
        }
    }
}

extension OpeaceApp {
    private func registerDependencies() {
        Task {
            await AppDIContainer.shared.registerDependencies()
        }
    }
}
