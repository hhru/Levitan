import SwiftUI

internal struct TokenThemeView<Content: View>: View {

    internal let content: Content

    @ObservedObject
    internal private(set) var themeManager: TokenThemeManager

    internal var body: some View {
        content
            .tokenThemeKey(themeManager.currentTheme.key)
            .tokenThemeScheme(themeManager.currentTheme.scheme)
    }
}

extension View {

    public func tokenThemeManager(_ themeManager: TokenThemeManager) -> some View {
        TokenThemeView(
            content: self,
            themeManager: themeManager
        )
    }
}
