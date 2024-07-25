import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
    name: "Foundations",
    bundleId: .appBundleID(name: ".Foundations"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .Networking(implements: .ThirdPartys),
        .Networking(implements: .API),
        .Networking(implements: .Utills),
        .SPM.keychainAccess
    ],
    sources: ["Sources/**"]
)
