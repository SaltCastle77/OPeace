import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let project = Project.makeModule(
    name: "Presentation",
    bundleId: .appBundleID(name: ".Presentation"),
    product: .staticFramework,
    settings:  .settings(),
    dependencies: [
        .Networking(implements: .Networkings),
        .Shared(implements: .Shareds)
        
    ],
    sources: ["Sources/**"]
)
