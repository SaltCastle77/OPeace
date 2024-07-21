import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let project = Project.makeAppModule(
    name: "Shareds",
    bundleId: .appBundleID(name: ".Shareds"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .Shared(implements: .DesignSystem),
        .Shared(implements: .ThirdParty),
        .Shared(implements: .Utill)
    ],
    sources: ["Sources/**"]
)
