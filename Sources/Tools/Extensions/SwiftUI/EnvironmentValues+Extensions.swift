#if canImport(UIKit)
import UIKit
import SwiftUI

@MainActor
extension EnvironmentValues {

    internal static let `default` = Self.default(for: UIScreen.main.traitCollection)

    internal static func `default`(for traitCollection: UITraitCollection) -> Self {
        var environment = EnvironmentValues()

        environment.displayScale = traitCollection.displayScale
        environment.colorScheme = colorScheme(for: traitCollection.userInterfaceStyle)
        environment.layoutDirection = layoutDirection(for: traitCollection.layoutDirection)
        environment.horizontalSizeClass = userInterfaceSizeClass(for: traitCollection.horizontalSizeClass)
        environment.verticalSizeClass = userInterfaceSizeClass(for: traitCollection.verticalSizeClass)
        environment.legibilityWeight = legibilityWeight(for: traitCollection.legibilityWeight)
        environment.sizeCategory = sizeCategory(for: traitCollection.preferredContentSizeCategory)

        if #available(iOS 15.0, tvOS 15.0, *) {
            environment.dynamicTypeSize = dynamicTypeSize(for: traitCollection.preferredContentSizeCategory)
        }

        return environment
    }

    private static func colorScheme(
        for uiUserInterfaceStyle: UIUserInterfaceStyle,
        defaultValue: ColorScheme? = nil
    ) -> ColorScheme {
        if let colorScheme = ColorScheme(uiUserInterfaceStyle) {
            return colorScheme
        }

        let systemUserInterfaceStyle = UIScreen
            .main
            .traitCollection
            .userInterfaceStyle

        return defaultValue ?? Self.colorScheme(
            for: systemUserInterfaceStyle,
            defaultValue: .light
        )
    }

    private static func layoutDirection(
        for uiLayoutDirection: UITraitEnvironmentLayoutDirection,
        defaultValue: LayoutDirection? = nil
    ) -> LayoutDirection {
        if let layoutDirection = LayoutDirection(uiLayoutDirection) {
            return layoutDirection
        }

        let systemLayoutDirection = UIScreen
            .main
            .traitCollection
            .layoutDirection

        return defaultValue ?? Self.layoutDirection(
            for: systemLayoutDirection,
            defaultValue: .leftToRight
        )
    }

    private static func userInterfaceSizeClass(
        for uiUserInterfaceSizeClass: UIUserInterfaceSizeClass
    ) -> UserInterfaceSizeClass? {
        #if os(iOS)
            return UserInterfaceSizeClass(uiUserInterfaceSizeClass)
        #elseif os(tvOS)
            return .regular
        #endif
    }

    private static func legibilityWeight(
        for uiLegibilityWeight: UILegibilityWeight
    ) -> LegibilityWeight? {
        LegibilityWeight(uiLegibilityWeight)
    }

    private static func sizeCategory(
        for uiSizeCategory: UIContentSizeCategory,
        defaultValue: ContentSizeCategory? = nil
    ) -> ContentSizeCategory {
        if let sizeCategory = ContentSizeCategory(uiSizeCategory) {
            return sizeCategory
        }

        let systemSizeCategory = UIScreen
            .main
            .traitCollection
            .preferredContentSizeCategory

        return defaultValue ?? Self.sizeCategory(
            for: systemSizeCategory,
            defaultValue: .medium
        )
    }

    @available(iOS 15.0, tvOS 15.0, *)
    private static func dynamicTypeSize(
        for uiSizeCategory: UIContentSizeCategory,
        defaultValue: DynamicTypeSize? = nil
    ) -> DynamicTypeSize {
        if let dynamicTypeSize = DynamicTypeSize(uiSizeCategory) {
            return dynamicTypeSize
        }

        let systemSizeCategory = UIScreen
            .main
            .traitCollection
            .preferredContentSizeCategory

        return defaultValue ?? Self.dynamicTypeSize(
            for: systemSizeCategory,
            defaultValue: .medium
        )
    }
}
#endif
