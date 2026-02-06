#if canImport(UIKit)
import UIKit
import SwiftUI

extension EnvironmentValues {

    @MainActor
    internal static var `default`: Self {
        Self.default(for: UIScreen.main.traitCollection)
    }

    internal static func `default`(for traits: UITraitCollection) -> Self {
        var environment = Self()

        environment.displayScale = traits.displayScale

        if let colorScheme = ColorScheme(traits.userInterfaceStyle) {
            environment.colorScheme = colorScheme
        }

        if let layoutDirection = LayoutDirection(traits.layoutDirection) {
            environment.layoutDirection = layoutDirection
        }

        if let horizontalSizeClass = UserInterfaceSizeClass(traits.horizontalSizeClass) {
            environment.horizontalSizeClass = horizontalSizeClass
        }

        if let verticalSizeClass = UserInterfaceSizeClass(traits.verticalSizeClass) {
            environment.verticalSizeClass = verticalSizeClass
        }

        if let sizeCategory = ContentSizeCategory(traits.preferredContentSizeCategory) {
            environment.sizeCategory = sizeCategory
        }

        if let legibilityWeight = LegibilityWeight(traits.legibilityWeight) {
            environment.legibilityWeight = legibilityWeight
        }

        if #available(iOS 17.0, tvOS 17.0, *) {
            if let allowedDynamicRange = Image.DynamicRange(traits.imageDynamicRange) {
                environment.allowedDynamicRange = allowedDynamicRange
            }
        }

        if #available(iOS 15.0, tvOS 15.0, *) {
            if let dynamicTypeSize = DynamicTypeSize(traits.preferredContentSizeCategory) {
                environment.dynamicTypeSize = dynamicTypeSize
            }
        }

        return environment
    }
}
#endif
