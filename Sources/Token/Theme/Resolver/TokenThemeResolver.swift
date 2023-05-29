import Foundation

public protocol TokenThemeResolver {

    func resolveTheme(
        selectedKey: TokenThemeKey?,
        selectedScheme: TokenThemeScheme?
    ) -> TokenTheme
}
