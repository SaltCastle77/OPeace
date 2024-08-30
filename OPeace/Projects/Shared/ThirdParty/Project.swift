import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeModule(
    name: "ThirdParty",
    bundleId: .appBundleID(name: ".ThirdParty"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .SPM.composableArchitecture,
        .SPM.concurrencyExtras,
        .SPM.sdwebImage,
        .SPM.collections,
        .SPM.kakaoSDKAuth,
        .SPM.kakaoSDKUser,
        .SPM.kakaoSDKCommon,
        .SPM.popupView,
        .SPM.firebaseAnalytics,
        .SPM.firebaseCrashlytics,
        .SPM.swiftUIIntrospect,
        .SPM.isEmojiView
    ],
    sources: ["Sources/**"]
)
