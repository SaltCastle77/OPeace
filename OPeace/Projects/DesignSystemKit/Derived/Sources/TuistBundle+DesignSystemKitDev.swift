// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
import Foundation

// MARK: - Swift Bundle Accessor

private class BundleFinder {}

extension Foundation.Bundle {
/// Since DesignSystemKit-Dev is a staticFramework, the bundle containing the resources is copied into the final product.
static let module: Bundle = {
    let bundleName = "DesignSystemKit_DesignSystemKit_Dev"

    let candidates = [
        Bundle.main.resourceURL,
        Bundle(for: BundleFinder.self).resourceURL,
        Bundle.main.bundleURL,
    ]

    for candidate in candidates {
        let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
        if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
            return bundle
        }
    }
    fatalError("unable to find bundle named DesignSystemKit_DesignSystemKit_Dev")
}()
}

// MARK: - Objective-C Bundle Accessor

@objc
public class DesignSystemKitDevResources: NSObject {
@objc public class var bundle: Bundle {
    return .module
}
}
// swiftlint:enable all
// swiftformat:enable all
