import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let project = Project.makeModule(
name: "API",
bundleId: .appBundleID(name: ".API"),
product: .staticFramework,
settings:  .settings(),
dependencies: [

],
sources: ["Sources/**"]
)
