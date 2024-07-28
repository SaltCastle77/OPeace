import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
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
        .SPM.popupView
    ],
    sources: ["Sources/**"]
)
