import Foundation

@MainActor
public protocol TokenThemeResolver {

    func resolveTheme(
        selectedKey: TokenThemeKey?,
        selectedScheme: TokenThemeScheme?
    ) -> TokenTheme
}
