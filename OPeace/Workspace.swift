//
//  WorkSpace.swift
//  Manifests
//
//  Created by 서원지 on 7/21/24.
//

import Foundation
import ProjectDescription
import ProjectTemplatePlugin


let workspace = Workspace(
name: Project.Environment.appName,
projects: [
    "Projects/**"
])
