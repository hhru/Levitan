import SwiftUI

extension EnvironmentValues {

    public var tokenTheme: TokenTheme {
        TokenTheme(
            key: tokenThemeKey,
            scheme: tokenThemeScheme
        )
    }
}
