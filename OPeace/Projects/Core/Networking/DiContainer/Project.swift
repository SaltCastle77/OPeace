import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let project = Project.makeModule(
    name: "DiContainer",
    bundleId: .appBundleID(name: ".DiContainer"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
      .Networking(implements: .ThirdPartys)
    ],
    sources: ["Sources/**"]
)
