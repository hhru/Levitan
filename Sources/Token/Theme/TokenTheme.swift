import Foundation

public struct TokenTheme: Equatable, Sendable {

    public let key: TokenThemeKey
    public let scheme: TokenThemeScheme

    public init(key: TokenThemeKey, scheme: TokenThemeScheme) {
        self.key = key
        self.scheme = scheme
    }
}

extension TokenTheme {

    public static let defaultLight = Self(
        key: .default,
        scheme: .light
    )

    public static let defaultDark = Self(
        key: .default,
        scheme: .dark
    )
}
