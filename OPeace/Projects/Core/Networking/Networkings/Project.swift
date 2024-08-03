import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let project = Project.makeAppModule(
    name: "Networkings",
    bundleId: .appBundleID(name: ".Networkings"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .Networking(implements: .Model),
        .Networking(implements: .Service),
        .Networking(implements: .DiContainer),
        .Networking(implements: .UseCase),
        .Networking(implements: .Foundations)
    ],
    sources: ["Sources/**"]
)
