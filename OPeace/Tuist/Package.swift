// swift-tools-version: 5.9
#if swift(>=6.0)
@preconcurrency import PackageDescription
#else
import PackageDescription
#endif

#if TUIST

#if swift(>=6.0)
@preconcurrency import ProjectDescription
#else
import ProjectDescription
#endif

    let packageSettings = PackageSettings(
        productTypes: [
                    :
        ], baseSettings: .settings(configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ])
    )
#endif

let package = Package(
    name: "AuraTarot",
    dependencies: [
        .package(url: "http://github.com/pointfreeco/swift-composable-architecture", from: "1.12.1"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-collections.git", branch: "main"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/exyte/PopupView.git", from: "2.10.4"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "2.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.1.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.21.0"),
        
    ]
)
