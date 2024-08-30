import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeModule(
    name: "Utills",
    bundleId: .appBundleID(name: ".Utills"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .sdk(name: "OSLog", type: .framework),
        .Networking(implements: .ThirdPartys),
    ],
    sources: ["Sources/**"]
)
