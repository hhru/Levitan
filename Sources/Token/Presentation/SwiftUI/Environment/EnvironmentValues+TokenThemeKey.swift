import SwiftUI

private struct TokenThemeKeyEnvironmentKey: EnvironmentKey {

    static let defaultValue = TokenThemeKey.default
}

extension EnvironmentValues {

    public var tokenThemeKey: TokenThemeKey {
        get { self[TokenThemeKeyEnvironmentKey.self] }
        set { self[TokenThemeKeyEnvironmentKey.self] = newValue }
    }
}

extension View {

    public nonisolated func tokenThemeKey(_ themeKey: TokenThemeKey) -> some View {
        environment(\.tokenThemeKey, themeKey)
    }
}
