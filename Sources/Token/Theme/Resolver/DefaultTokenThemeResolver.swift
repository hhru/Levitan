import UIKit

public final class DefaultTokenThemeResolver: TokenThemeResolver {

    private var systemThemeScheme: TokenThemeScheme {
        let uiUserInterfaceStyle = UIScreen
            .main
            .traitCollection
            .userInterfaceStyle

        return TokenThemeScheme(uiUserInterfaceStyle: uiUserInterfaceStyle) ?? .light
    }

    public init() { }

    public func resolveTheme(
        selectedKey: TokenThemeKey?,
        selectedScheme: TokenThemeScheme?
    ) -> TokenTheme {
        TokenTheme(
            key: selectedKey ?? .default,
            scheme: selectedScheme ?? systemThemeScheme
        )
    }
}
