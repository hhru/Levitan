import SwiftUI

extension EnvironmentValues {

    public var tokenThemeScheme: TokenThemeScheme {
        get { TokenThemeScheme(colorScheme: colorScheme) }
        set { colorScheme = newValue.colorScheme }
    }
}

extension View {

    public nonisolated func tokenThemeScheme(_ themeScheme: TokenThemeScheme) -> some View {
        environment(\.tokenThemeScheme, themeScheme)
    }
}
