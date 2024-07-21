//
//  Project+Enviorment.swift
//  MyPlugin
//
//  Created by 서원지 on 1/6/24.
//

import Foundation
import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "OPeace"
        public static let appDemoName = "OPeace-Demo"
        public static let appDevName = "OPeace-Dev"
        public static let deploymentTarget : ProjectDescription.DeploymentTargets = .iOS("17.0")
        public static let deploymentDestination: ProjectDescription.Destinations = [.iPhone]
        public static let organizationTeamId = "N94CS4N6VR"
        public static let bundlePrefix = "io.Opeace.Opeace"
        public static let appVersion = "1.0.0"
        public static let mainBundleId = "io.Opeace.Opeace"
    }
}
