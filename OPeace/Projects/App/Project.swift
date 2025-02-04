//
//  Project.swift
//  Manifests
//
//  Created by 서원지 on 7/21/24.
//

import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin

let infoPlist: [String: Plist.Value] = InfoPlistValues.generateInfoPlist()

let project = Project.makeAppModule(
    name: Project.Environment.appName,
    bundleId: .mainBundleID(),
    product: .app,
    settings: .appMainSetting,
    scripts: [],
    dependencies: [
        .Shared(implements: .Shareds),
        .Networking(implements: .Networkings),
        .Presentation(implements: .Presentation)
    ],
    sources: ["Sources/**"],
    resources: ["Resources/**", "PrivacyInfo.xcprivacy"],
    infoPlist: .extendingDefault(with: infoPlist),
    entitlements: .file(path: "../../Entitlements/OPeace.entitlements"),
    schemes: [
        Scheme.makeScheme(target: .release, name: Project.Environment.appName),
//        Scheme.makeTestPlanScheme(target: .debug, name: Project.Environment.appName)
    ]
)
