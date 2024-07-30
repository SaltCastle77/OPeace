import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
    name: "UseCase",
    bundleId: .appBundleID(name: ".UseCase"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .Networking(implements: .DiContainer),
        .Networking(implements: .Service),
        .Networking(implements: .Model),
        .SPM.composableArchitecture,
    ],
    sources: ["Sources/**"]
)
