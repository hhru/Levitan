import Foundation

public protocol TokenThemeResolver {

    @MainActor
    func resolveTheme(
        selectedKey: TokenThemeKey?,
        selectedScheme: TokenThemeScheme?
    ) -> TokenTheme
}
