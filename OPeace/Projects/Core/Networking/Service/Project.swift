import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let project = Project.makeModule(
    name: "Service",
    bundleId: .appBundleID(name: ".Service"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .Networking(implements: .API),
        .Networking(implements: .Foundations),
        .Networking(implements: .ThirdPartys)
    ],
    sources: ["Sources/**"]
)
