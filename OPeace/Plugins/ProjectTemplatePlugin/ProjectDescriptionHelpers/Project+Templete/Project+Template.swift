//
//  Project+Template.swift
//  MyPlugin
//
//  Created by 서원지 on 1/6/24.
//

import ProjectDescription

public extension Project {
  static func makeAppModule(
    name: String = Environment.appName,
    bundleId: String,
    platform: Platform = .iOS,
    product: Product,
    packages: [Package] = [],
    deploymentTarget: ProjectDescription.DeploymentTargets = Environment.deploymentTarget,
    destinations: ProjectDescription.Destinations = Environment.deploymentDestination,
    settings: ProjectDescription.Settings,
    scripts: [ProjectDescription.TargetScript] = [],
    dependencies: [ProjectDescription.TargetDependency] = [],
    sources: ProjectDescription.SourceFilesList = ["Sources/**"],
    resources: ProjectDescription.ResourceFileElements? = nil,
    infoPlist: ProjectDescription.InfoPlist = .default,
    entitlements: ProjectDescription.Entitlements? = nil,
    schemes: [ProjectDescription.Scheme] = []
  ) -> Project {
    
    let appTarget: Target = .target(
      name: name,
      destinations: destinations,
      product: product,
      bundleId: bundleId,
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )
    
    let appDevTarget: Target = .target(
      name: "\(name)-QA",
      destinations: destinations,
      product: product,
      bundleId: "\(bundleId)",
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )
    
    let appTestTarget : Target = .target(
      name: "\(name)Tests",
      destinations: destinations,
      product: .unitTests,
      bundleId: "\(bundleId).\(name)Test",
      deploymentTargets: deploymentTarget,
      infoPlist: .default,
      sources: ["\(name)Tests/Sources/**"],
      resources: ["\(name)Tests/Sources/OpeaceTestPlan.xctestplan"],
      dependencies: [
        .target(name:name),
        //                .sdk(name: "Testing", type: .framework, status: isXcodeVersion16OrAbove() ? .required : .optional),
      ]
    )
    
    
    let targets = [appTarget, appDevTarget, appTestTarget]
    
    return Project(
      name: name,
      options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
      ),
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: [
        Scheme.makeScheme(target: .debug, name: name),
        Scheme.makeScheme(target: .release, name: name),
        Scheme.makeScheme(target: .debug, name: "\(name)-QA")
      ]
    )
  }
  
  static func isXcodeVersion16OrAbove() -> Bool {
#if swift(>=6.0)
    // Assuming Swift 5.7 is available with Xcode 14 and above,
    // adjust if more accurate version checking is needed
    return true
#else
    return false
#endif
  }
  
  
  static func makeModule(
    name: String = Environment.appName,
    bundleId: String,
    platform: Platform = .iOS,
    product: Product,
    packages: [Package] = [],
    deploymentTarget: ProjectDescription.DeploymentTargets = Environment.deploymentTarget,
    destinations: ProjectDescription.Destinations = Environment.deploymentDestination,
    settings: ProjectDescription.Settings,
    scripts: [ProjectDescription.TargetScript] = [],
    dependencies: [ProjectDescription.TargetDependency] = [],
    sources: ProjectDescription.SourceFilesList = ["Sources/**"],
    resources: ProjectDescription.ResourceFileElements? = nil,
    infoPlist: ProjectDescription.InfoPlist = .default,
    entitlements: ProjectDescription.Entitlements? = nil,
    schemes: [ProjectDescription.Scheme] = []
  ) -> Project {
    
    let appTarget: Target = .target(
      name: name,
      destinations: destinations,
      product: product,
      bundleId: bundleId,
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )
    
    let appDevTarget: Target = .target(
      name: "\(name)-QA",
      destinations: destinations,
      product: product,
      bundleId: "\(bundleId)",
      deploymentTargets: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      entitlements: entitlements,
      scripts: scripts,
      dependencies: dependencies
    )
    
    let appTestTarget : Target = .target(
      name: "\(name)Tests",
      destinations: destinations,
      product: .unitTests,
      bundleId: "\(bundleId).\(name)Tests",
      deploymentTargets: deploymentTarget,
      infoPlist: .default,
      sources: ["\(name)Tests/Sources/**"],
      dependencies: [.target(name: name)]
    )
    
    let targets = [appTarget, appDevTarget, appTestTarget]
    
    return Project(
      name: name,
      options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
      ),
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}



extension Scheme {
  public static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
    // Scheme 이름을 "앱 이름 + 타겟 이름" 형식으로 생성
    let schemeName = "\(name)_\(target.rawValue)"
    
    // Run Action 설정 (Debug일 때만 디버거 첨부)
    let runAction = target == .debug
    ? RunAction.runAction(
      configuration: target,
      attachDebugger: true,
      arguments: .arguments(
        launchArguments: [
          .launchArgument(name: "-FIRDebugEnabled", isEnabled: true)
        ]
      )
    )
    : RunAction.runAction(
      configuration: target,
      attachDebugger: true,
      arguments: .arguments(
        launchArguments: [
          .launchArgument(name: "-FIRDebugEnabled", isEnabled: true)
        ]
      )
    )
    
    return Scheme.scheme(
      name: schemeName,  // 동적으로 생성된 Scheme 이름 사용
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: target,
        options: .options(coverage: target == .debug, codeCoverageTargets: ["\(name)"])
      ),
      runAction: runAction,
      archiveAction: .archiveAction(configuration: target),
      profileAction: .profileAction(configuration: target),
      analyzeAction: .analyzeAction(configuration: target)
    )
  }
  
  public func makeTestPlanScheme(target: ConfigurationName, name: String) -> Scheme {
    return Scheme.scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)", "\(name)Tests"]),
      testAction: .testPlans(["\(name)Tests/Sources/\(name)TestPlan.xctestplan"]),
      runAction: .runAction(configuration: "Debug"),
      archiveAction: .archiveAction(configuration: "Debug"),
      profileAction: .profileAction(configuration: "Debug"),
      analyzeAction: .analyzeAction(configuration: "Debug")
    )
  }
}


