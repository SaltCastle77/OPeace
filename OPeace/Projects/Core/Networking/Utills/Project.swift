import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let project = Project.makeAppModule(
    name: "Utills",
    bundleId: .appBundleID(name: ".Utills"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .sdk(name: "OSLog", type: .framework),
        .Networking(implements: .ThirdPartys)
    ],
    sources: ["Sources/**"]
)
